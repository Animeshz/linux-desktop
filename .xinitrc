run_cmd() {
  command -v "$1" 1>/dev/null && "$@"
}

# Syncs Xresources
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources &

# Topbar
run_cmd eww open topbar &

# Key hold-repeat frequency
xset r rate 300 50

# Touchpad configuration
xinput list \
| awk '/Touchpad/ {print $6}' \
| cut -d'=' -f2 \
| while read -r touchpad_id; do
    xinput --set-prop $touchpad_id 313 1      # Tap
    xinput --set-prop $touchpad_id 315 1      # Drag
    xinput --set-prop $touchpad_id 317 0      # Drag Lock
    xinput --set-prop $touchpad_id 310 1      # Horizontal Scroll
    xinput --set-prop $touchpad_id 291 1      # Natural Scrolling
    xinput --set-prop $touchpad_id 321 0      # Disable while Typing
    xinput --set-prop $touchpad_id 294 1 0 0  # Scroll Method (two-finger, edge, button)
    xinput --set-prop $touchpad_id 324 1 0    # Click Method (button-areas, click-finger) (see: 1)
    xinput --set-prop $touchpad_id 302 0.5    # Accel Speed
    xinput --set-prop $touchpad_id 305 1 0    # Accel Profile (adaptive, flat)
    xinput --set-prop $touchpad_id 277 0 0    # Send event modes (see: 2)
  done &

exec herbstluftwm --locked

# 1: click-finger allows only two-finger tap behave as right-click and three-finger tap as middle,
#    whereas button-areas adds right-side and middle-side realistic click recognition additionally (to above).
# 2: 0,0: enabled;; 1,0: disabled;; 0,1: disabled-when-external-mouse
