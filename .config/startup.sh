#!/usr/bin/env bash

# Startup script to be run by /etc/rc.local if exists as root
# Donot use it, its at experimental stage right now
<< ////
# Executes ~/.config/startup.sh for each user, if exists
ls /home \
| while read user; do
    startup_script="/home/$user/.config/startup"
    if [ -f "$startup_script" ]; then
      "$startup_script"
    fi
  done
////

# Check for superuser access
if [[ $EUID -ne 0 ]]; then
  >&2 echo "This script must be run as root"
  exit 1
fi

run_cmd() {
  command -v "$1" 1>/dev/null && "$@"
}


# Power saving

echo 5 > /proc/sys/vm/laptop_mode
echo 0 > /proc/sys/kernel/nmi_watchdog
echo 1500 > /proc/sys/vm/dirty_writeback_centisecs

echo 1 > /sys/module/snd_hda_intel/parameters/power_save
echo Y > /sys/module/snd_hda_intel/parameters/power_save_controller

echo powersupersave > /sys/module/pcie_aspm/parameters/policy  # powersave

run_cmd ryzenadj --power-saving

