#TODO: Break xbps-src setup into two parts, one for cloning and one for xpackages
#TODO: Somehow make a way to install package coming from here at 01-checks (basic steps)
setup_xbps_src() {
    echo_step "Setting up xbps-src (void-packages)"; echo
    if $XBPS_SRC_SETUP; then
        if [[ ! -d "$XBPS_SRC_SETUP_PATH" ]]; then
            echo_step "  Cloning void-packages repository and setting upstreams"
            git clone "$VOID_REPO_USER" "$XBPS_SRC_SETUP_PATH"

            pushd $XBPS_SRC_SETUP_PATH
            git remote add --fetch upstream $VOID_REPO_UPSTREAM
            git remote add --fetch xpackages https://github.com/Animeshz/void-xpackages
            popd
            echo_success
        fi
        XBPS_SRC_SETUP_FINISHED=true
    fi
}

install_pkgs() {
    echo_step "Package Installation"

    # TODO: After multi-select filter from enquirer

    local any_installed=0
    local tmp=$(mktemp); xbps-query -m > ${tmp};
    local pkgs=$(cat ${BASH_SOURCE%/*}/packages.txt | sed '/^#/d' | xargs -I{} bash -c "! grep -q {} ${tmp} && echo {}")
    if [[ -z ${pkgs} ]]; then
        echo_success
    else
        echo
        for pkg in $pkgs; do
            install_pkg $pkg
        done
        rm ${tmp}
    fi
}

bootstrap_distro() {
    setup_xbps_src
    sync_install_pkg
    install_pkgs
}

