#!/usr/bin/sh

term=$(ps -p $(ps -p $(ps -p $$ -o ppid=) -o ppid=) -o args= | cut -d' ' -f1)

if [ $term = 'kitty' ]; then
    kitty @ set-spacing padding=15
elif [ $term = 'tmux' -a $(ps -p $(active-window-pid) -o args= | cut -d' ' -f1) = 'kitty' ]; then
    # https://github.com/kovidgoyal/kitty/issues/2338
    # kitty @ set-spacing padding=15
    exit 0
fi
