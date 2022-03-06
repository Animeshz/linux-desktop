#!/bin/sh
# Default acpi script that takes an entry for all actions

# NOTE: This is a 2.6-centric script.  If you use 2.4.x, you'll have to
#       modify it to not use /sys

# $1 should be + or - to step up or down the brightness.
step_backlight() {
    for backlight in /sys/class/backlight/*/; do
        [ -d "$backlight" ] || continue
        step=$(( $(cat "$backlight/max_brightness") / 20 ))
        [ "$step" -gt "1" ] || step=1 #fallback if gradation is too low
        printf '%s' "$(( $(cat "$backlight/brightness") $1 step ))" >"$backlight/brightness"
    done
}

minspeed=$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq)
maxspeed=$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq)
setspeed="/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed"

join() { local ifs=$1; shift; echo "$*"; }
PATH=$PATH:$(join ':' $(ls /home | xargs -I{} echo /home/{}/.scripts/acpi))

case "$1" in
    button/power)
        case "$2" in
            PBTN|PWRF)
                logger "PowerButton pressed: $2, suspending" #, shutting down..."
                slp
                #shutdown -P now
                ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;
    button/sleep)
        case "$2" in
            SBTN|SLPB)
                # suspend-to-ram
                logger "Sleep Button pressed: $2, suspending..."
                slp
                #zzz
                ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;
    ac_adapter)
        case "$2" in
            AC|ACAD|ADP0)
                case "$4" in
                    00000000)
                        printf '%s' "$minspeed" >"$setspeed"
                        #/etc/laptop-mode/laptop-mode start
                    ;;
                    00000001)
                        printf '%s' "$maxspeed" >"$setspeed"
                        #/etc/laptop-mode/laptop-mode stop
                    ;;
                esac
                ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;
    battery)
        case "$2" in
            BAT0)
                case "$4" in
                    00000000)   #echo "offline" >/dev/tty5
                    ;;
                    00000001)   #echo "online"  >/dev/tty5
                    ;;
                esac
                ;;
            CPU0)
                ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;
    button/lid)
        case "$3" in
            close)
                # suspend-to-ram
                logger "LID closed, suspending..."
                slp
                ;;
            open)
                logger "LID opened"
                ;;
            *)  logger "ACPI action undefined (LID): $2";;
        esac
        ;;
    video/brightnessdown)
        command -v bridn && bridn || step_backlight +
        ;;
    video/brightnessup)
        command -v briup && briup || step_backlight -
        ;;
    button/mute)
        command -v mute && mute
        ;;
    button/volumedown)
        command -v voldn && voldn
        ;;
    button/volumeup)
        command -v volup && volup
        ;;
    # cd/prev cd/next cd/play delegated to WM instead of here to use with per-user basis
    *)
        logger "ACPI group/action undefined: $1 / $2"
        ;;
esac
