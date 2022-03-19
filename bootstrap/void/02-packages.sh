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
    echo_step "  Syncing repository"

    xbps-install -S &>/dev/null \
    && echo_success || exit_with_failure "Unable to sync repository, try running xbps-install -S manually"
}
install_pkg() {
    echo_step "  Installing package $pkg"

    if output=$( \
        [[ -f "$1" ]] && chmod u+x "$1" && "$1" \
        || xbps-install -y "$1" \
        || xbps_src_install "$1" \
        || xpackages_install "$1" \
    ); then
        echo_success
    else
        exit_with_failure "Unable to install $pkg"
        echo "Command output:"
        printf '%s\n' $output
    fi
}

xbps_src_install() {
    :
}
xpackages_install() {
    :
}
