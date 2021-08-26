# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
. "$HOME/.cargo/env"

alias dothide="yadm sparse-checkout set '/*' '!README.md' '!UNLICENSE' '!Makefile' && yadm checkout --quiet"
alias dotunhide="yadm sparse-checkout set '/*' && yadm checkout --quiet"
