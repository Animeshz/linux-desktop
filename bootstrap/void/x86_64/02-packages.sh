# locates package name for given binary
sync_locate_cmd() {
    if ! command_exists xlocate; then
        echo_step "  xlocate not found, installing xtools"
        install_pkg xtools
    fi

    echo_step "  Syncing xlocate"
    run_with_user $user "xlocate -S &>/dev/null" && echo_success || exit_with_failure
}
locate_cmd() {
    local script="./pkgs/$1"
    [[ -f "$script" ]] && echo "$script" && true

    run_with_user $user "xlocate '^/usr/bin/${1}\( ->.*\)\?$'" \
    | awk '{print $1}' \
    | xargs -I{} sh -c 'xbps-query -Rs {} | grep -iv "xbps-src" 1>/dev/null && echo {}' \
    | head -n1 \
    | grep ^  # if no result error out
}

# installs package generically
sync_install_pkg() {
    echo_step "  Syncing void repository index"
    if output=$(xbps-install -S); then
        echo_success
    else
        echo_failure "Unable to sync repository, try running 'git pull' on void-packages manually"
        echo "Command output:"
        printf '%s\n' $output
        exit 1
    fi

    echo_step "  Syncing xpackages repository"
    if output=$(sync_xpackages 2>&1); then
        echo_success
    else
        echo_failure "Unable to sync repository, try running 'git fetch xpackages/main && git merge -s subtree -Xsubtree=srcpkgs xpackages/main --allow-unrelated-histories --no-edit --no-gpg-sign' on void-packages manually"
        echo "Command output:"
        printf '%s\n' $output
        exit 1
    fi
}
sync_xpackages() {
    if ${XBPS_SRC_SETUP_FINISHED:-false} && [[ -z $(git status --porcelain) ]]; then
        pushd ${XBPS_SRC_SETUP_PATH}
        run_with_user $user \
            'git fetch upstream master \
            && git checkout master \
            && git reset --hard upstream/master

            commit_before_fetch=$(git rev-parse xpackages/main)
            git fetch xpackages main
            if [[ $(git rev-parse xpackages/main) != $commit_before_fetch ]]; then
                git checkout xpack \
                && git reset --hard upstream/master \
                && git merge -s subtree -Xsubtree=srcpkgs xpackages/main --allow-unrelated-histories --no-edit --no-gpg-sign
            fi'
        ret=$?
        popd
    fi
    return $ret
}

install_pkg() {
    echo_step "  Installing package $pkg"

    if output=$([[ -f "$1" ]] && chmod u+x "$1" && "$1" 2>&1); then
        echo_success "SCRIPT"
    elif output=$(xbps-install -y "$1" 2>&1); then
        echo_success "VOID-REPO"
    elif ($XBPS_SRC_SETUP || echo_warning "" "XBPS-SRC | can't be installed w/o xbps-src" && false) && \
        output=$(xbps_src_install "$1" 2>&1); then
        echo_success "XBPS-SRC"
    elif $XBPS_SRC_SETUP && output=$(xpackages_install "$1" 2>&1); then
        echo_success "XPACK"
    else
        echo_failure "Unable to install $pkg"
        echo "Command output:"
        printf '%s\n' $output
        exit 1
    fi
}
query_pkg() {
    xbps-query -m | grep "^$1-" 1>/dev/null
    return $?
}

xbps_src_install() {
    if ! ${XBPS_SRC_SETUP_FINISHED:-false}; then
        exit_with_failure "Packages from xbps-src are not available until Bootstrap step"
    fi

    pushd ${XBPS_SRC_SETUP_PATH}
    run_with_user $user "git checkout master && ./xbps-src pkg '$1'"
    xbps-install -R hostdir/binpkgs -y "$1" || xbps-install -R hostdir/binpkgs/nonfree -y "$1"
    ret=$?
    popd
    return $ret
}

xpackages_install() {
    if ! ${XBPS_SRC_SETUP_FINISHED:-false}; then
        exit_with_failure "Packages from xpackages are not available until Bootstrap step"
    fi

    pushd ${XBPS_SRC_SETUP_PATH}
    run_with_user $user "git checkout xpack && ./xbps-src pkg '$1'"
    xbps-install -R hostdir/binpkgs/xpack -y "$1" || xbps-install -R hostdir/binpkgs/xpack/nonfree -y "$1"
    ret=$?
    popd
    return $ret
}
