#alias sudo='sudo '  # Hack: https://askubuntu.com/a/22043/669216 does not work in fish
alias snvim='sudo -E nvim'
alias nv='kitty-nopad nvim'
alias snv='sudo -E kitty-nopad nvim'
alias hc='herbstclient'
alias tree='tree -C'
alias jl='jupyter-lab --notebook-dir=/home/animesh/Projects/GeneralPurpose/JupyterLab'
alias :q='exit'
alias lsblk="lsblk -o NAME,MODEL,MAJ:MIN,TRAN,FSTYPE,RM,SIZE,RO,LABEL,MOUNTPOINTS"

alias audio="inxi -A";
alias battery="inxi -B";
alias bluetooth="inxi -E";
alias fonts="kitty +list-fonts";
alias graphics="inxi -G";
alias pci="sudo inxi --slots";
alias process="inxi --processes";
alias partitions="inxi -P"
alias repos="inxi -r";
alias sockets="ss -lp";
alias system="inxi -Fazy";
alias usb="inxi -J";
alias wifi="inxi -n";

alias macros="cpp -dM /dev/null"
