# if status is-interactive
    # Commands to run in interactive sessions can go here
# end

function fish_user_key_bindings
    fish_default_key_bindings -M insert
    #fish_vi_key_bindings --no-erase insert

    bind \cX "fish_commandline_append '| xclip -sel clip'"
    bind \cV "fish_commandline_prepend_full 'xclip -sel clip -o |'"  # https://github.com/fish-shell/fish-shell/issues/8763
end

fish_add_path (fd -td -d1 . ~/.scripts 2>/dev/null || find ~/.scripts -type d -maxdepth 1)
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.emacs.d/bin
fish_add_path /usr/lib/ruby/gems/3.0.0/bin
fish_add_path /opt/flutter/bin
fish_add_path ~/Projects/RustProjects/eww/target/release

set fish_greeting

# https://stackoverflow.com/a/42265848/11377112
set -x GPG_TTY (tty)
set -x PKG_CONFIG_PATH /usr/lib/pkgconfig
set -x CHROME_EXECUTABLE /bin/brave-browser-stable  # for flutter

starship init fish | source

#alias sudo='sudo '  # Hack: https://askubuntu.com/a/22043/669216 does not work in fish
alias snvim='sudo -E nvim'
alias nv='~/.config/nvchad/scripts/startup.sh && nvim $argv; ~/.config/nvchad/scripts/exit.sh'
alias snv='~/.config/nvchad/scripts/startup.sh && sudo -E nvim $argv; ~/.config/nvchad/scripts/exit.sh'
alias hc='herbstclient'
alias jl='jupyter-lab --notebook-dir=/home/animesh/Projects/GeneralPurpose/JupyterLab'
alias dothide="yadm sparse-checkout set '/*' '!README.md' '!UNLICENSE' '!Makefile' && yadm checkout --quiet"
alias dotunhide="yadm sparse-checkout set '/*' && yadm checkout --quiet"

export PATH="$PATH:$HOME/.spicetify"
