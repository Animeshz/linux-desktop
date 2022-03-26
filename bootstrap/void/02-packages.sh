# locates package name for given binary
sync_locate_cmd() {
    if ! command_exists xlocate; then
        echo_step "  xlocate not found, installing xtools"
        install xtools &>/dev/null && echo_success || exit_with_failure
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
    echo_step "  Syncing repository"; echo

    echo_step "    Syncing void repository"
    if output=$(xbps-install -S); then
        echo_success
    else
        echo_failure "Unable to sync repository, try running 'git pull' on void-packages manually"
        echo "Command output:"
        printf '%s\n' $output
        exit 1
    fi

    echo_step "    Syncing xbps-src repository"
    if output=$(sync_xbps_src 2>&1); then
        echo_success
    else
        echo_failure "Unable to sync repository, try running 'git pull' on void-packages manually"
        echo "Command output:"
        printf '%s\n' $output
        exit 1
    fi
}
sync_xbps_src() {
    pushd ${XBPS_SRC_SETUP_PATH}
    if [[ -z $(git status --porcelain) ]] && ${XBPS_SRC_SETUP_FINISHED:-false}; then
        run_with_user $user '\
            git fetch upstream master \
            && git checkout master \
            && git reset --hard upstream/master \
            && git checkout xpack \
            && git reset --hard upstream/master \
            && git merge -s subtree -Xsubtree=srcpkgs xpackages/main --allow-unrelated-histories --no-edit --no-gpg-sign'
        ret=$?
    fi
    popd
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

xbps_src_install() {
    if ! ${XBPS_SRC_SETUP_FINISHED:-false}; then
        exit_with_failure "Packages from xbps-src are not available until Bootstrap step"
    fi

    pushd ${XBPS_SRC_SETUP_PATH}
    run_with_user $user "git checkout master && ./xbps-src pkg '$1'"
    xbps-install -R hostdir/binpkgs "$1" || xbps-install -R hostdir/binpkgs/nonfree "$1"
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
    xbps-install -R hostdir/binpkgs/xpack "$1" || xbps-install -R hostdir/binpkgs/xpack/nonfree "$1"
    ret=$?
    popd
    return $ret
}
