# if status is-interactive
    # Commands to run in interactive sessions can go here
# end

fish_add_path ~/.scripts
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.emacs.d/bin
fish_add_path /usr/lib/ruby/gems/3.0.0/bin
fish_add_path ~/Projects/RustProjects/eww/target/release

set fish_greeting

# https://stackoverflow.com/a/42265848/11377112
set -x GPG_TTY (tty)
set -x PKG_CONFIG_PATH /usr/lib/pkgconfig

starship init fish | source

alias snvim='sudo -E nvim'
alias hc='herbstclient'
alias dothide="yadm sparse-checkout set '/*' '!README.md' '!UNLICENSE' '!Makefile' && yadm checkout --quiet"
alias dotunhide="yadm sparse-checkout set '/*' && yadm checkout --quiet"
