# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
. "$HOME/.cargo/env"

# https://stackoverflow.com/a/42265848/11377112
export GPG_TTY=$(tty)

. /etc/environment

alias dothide="yadm sparse-checkout set '/*' '!README.md' '!UNLICENSE' '!bootstrap' && yadm checkout --quiet"
alias dotunhide="yadm sparse-checkout set '/*' && yadm checkout --quiet"

export PATH="$PATH:$(fd -td -d1 . ~/.scripts 2>/dev/null || find ~/.scripts -type d -maxdepth 1):~/.local/bin:~/.cargo/bin:~/.emacs.d/bin:/usr/lib/ruby/gems/3.0.0/bin:/opt/flutter/bin:~/Projects/RustProjects/eww/target/release"

export PATH="$PATH:$HOME/.spicetify"
