#alias sudo='sudo '  # Hack: https://askubuntu.com/a/22043/669216 does not work in fish
alias snvim='sudo -E nvim'
alias nv='~/.config/nvchad/scripts/startup.sh && nvim $argv; ~/.config/nvchad/scripts/exit.sh'
alias snv='~/.config/nvchad/scripts/startup.sh && sudo -E nvim $argv; ~/.config/nvchad/scripts/exit.sh'
alias hc='herbstclient'
alias tree='tree -C'
alias jl='jupyter-lab --notebook-dir=/home/animesh/Projects/GeneralPurpose/JupyterLab'
alias dothide="yadm sparse-checkout set '/*' '!README.md' '!UNLICENSE' '!bootstrap' && yadm checkout --quiet"
alias dotunhide="yadm sparse-checkout set '/*' && yadm checkout --quiet"
