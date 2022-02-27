#!/usr/bin/sh

term=$(ps -p $(ps -p $(ps -p $$ -o ppid=) -o ppid=) -o args= | cut -d' ' -f1)

[ $term = 'kitty' ] && kitty @ set-spacing padding=0
