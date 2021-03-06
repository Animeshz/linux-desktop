source "$SCRIPT_DIR/$distro/$arch/05-bootstrap.sh"

setup_scripts() {
    echo_step "Setup Scripts"; echo
    if [[ -d "$SCRIPTS_HOME" ]]; then
        echo_step "  Syncing scripts in $SCRIPTS_HOME"
        [[ -d "$SCRIPTS_HOME/.git" ]] || exit_with_failure "~/.scripts exists but is not a git repository"

        run_with_user $user "git -C "$SCRIPTS_HOME" pull --ff-only --no-edit &>/dev/null" \
        && echo_success || exit_with_failure "Unable to sync repository"
    else
        echo_step "  Cloning scripts into $SCRIPTS_HOME"
        run_with_user $user "git clone $SCRIPTS_URL $SCRIPTS_HOME &>/dev/null" \
        && echo_success || exit_with_failure "Unable to clone repository"
    fi

    if ! echo $PATH | grep -q "$SCRIPTS_HOME"; then
        echo_step "  Adding scripts to PATH"; echo;
        # TODO: not implemented xD
        #$rcfiles
    fi
}

setup_nvchad() {
    echo_step "Setup NvChad"
    echo_warning "" "SKIP"
    # [ -d ~/.config/nvim ] && { echo "Moving ~/.config/nvim to ~/.config/nvim.back"; mv ~/.config/nvim ~/.config/nvim.back; }

    # git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
    # nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
    # ln -sf ~/.config/nvchad ~/.config/nvim/lua/custom
}

setup_screen_dpi() {
    echo_step "Setting up screen dpi"
    # TODO: PATH addition doesn't reflect without shell restart
    local config=$(gen-monitor-dpi $SCREEN_SIZES)
    if echo $config | grep -q '\b0 0\b'; then
        rm /etc/X11/xorg.conf.d/90-monitor.conf
        echo_failure
    else
        mkdir -p /etc/X11/xorg.conf.d
        echo "$config" > /etc/X11/xorg.conf.d/90-monitor.conf
        echo_success
    fi
}

