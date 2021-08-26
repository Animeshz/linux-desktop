# if status is-interactive
    # Commands to run in interactive sessions can go here
# end

fish_add_path ~/.scripts
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
fish_add_path /usr/lib/ruby/gems/3.0.0/bin

set fish_greeting

starship init fish | source

alias hc='herbstclient'
alias dothide="yadm sparse-checkout set '/*' '!README.md' '!UNLICENSE' '!Makefile' && yadm checkout --quiet"
alias dotunhide="yadm sparse-checkout set '/*' && yadm checkout --quiet"
