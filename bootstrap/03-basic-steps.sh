setup_sparse_checkout() {
    echo_step "Setting up sparse checkout"

    run_with_user $user "yadm gitconfig core.sparseCheckout true" \
    && echo_success || exit_with_failure
}

setup_sparse_toggle_alias() {
    # adds aliases to fish, zsh & bash if they exists for hiding/unhiding README, UNLICENSE and Makefile.
    echo_step "Setting up sparse checkout toggle aliases (dothide & dotunhide)"; echo

    local dothide="alias dothide=\"yadm sparse-checkout set '/*' '!README.md' '!UNLICENSE' '!bootstrap' && yadm checkout --quiet\""
    local dotunhide="alias dotunhide=\"yadm sparse-checkout set '/*' && yadm checkout --quiet\""

    local files=$(run_with_user $user 'echo "$HOME/.config/fish/config.fish" "$HOME/.zshrc" "$HOME/.bashrc"')
    for config in $files; do
        echo_step "  in $config"
        if [[ -f "$config" ]]; then
            grep -qxF "$dothide" "$config" || echo "$dothide" >> "$config"
            grep -qxF "$dotunhide" "$config" || echo "$dotunhide" >> "$config"
            echo_success
        else
            echo_warning "" "NOT_FOUND"
        fi
    done
}



