run_cmd() {
  command -v "$1" 1>/dev/null && "$@"
}

[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources &
xset r rate 300 50

run_cmd eww open topbar &

exec herbstluftwm --locked
