xset r rate 300 50

cmd_exists() {
  command -v "$1" 1>/dev/null
}

cmd_exists pipewire && pipewire &
cmd_exists eww && eww open topbar &

exec herbstluftwm --locked
