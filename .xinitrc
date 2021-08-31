xset r rate 300 50

if command -v pipewire 1> /dev/null; then
  pipewire &
fi

exec herbstluftwm --locked
