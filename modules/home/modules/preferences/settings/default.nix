{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.misc.settings;
in
{
  options = {
    misc.settings.apply = mkEnableOption "Apply some misc personal preferences";
  };

  config = mkIf cfg.apply {
    home.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
      PKG_CONFIG_PATH = "/usr/lib/pkgconfig";
      BROWSER = "brave";            # for xdg-open   # TODO: https://github.com/nix-community/home-manager/issues/4723
      CHROME_EXECUTABLE = "brave";  # for flutter
      ANT_HOME = "/usr/share/apache-ant";                                # for jar builds (mainly emuArm)
      GOROOT = "/usr/lib/go";
      GOPATH = "$HOME/.go";
      ANDROID_HOME = "$HOME/.android-data/Sdk";
      NDK_HOME = "$HOME/.android-data/Ndk";
      PNPM_HOME = "/home/animesh/.local/share/pnpm";
      RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
      PATH = "$PATH:$(${pkgs.ruby}/bin/gem env 2>/dev/null | ${pkgs.gnugrep}/bin/grep 'EXECUTABLE DIRECTORY' | ${pkgs.gnused}/bin/sed --quiet \"s/.*EXECUTABLE DIRECTORY: \(.*\)/\1/p\"):$(${pkgs.fd}/bin/fd -td -d1 . ~/.scripts 2>/dev/null | tr '\\n' ':')";
    };

    home.sessionPath = [
      "/usr/bin"
      "/usr/local/bin"
      "/usr/lib/ruby/gems/3.2.0/bin"
      "/opt/flutter/bin"
      "/opt/chef-workstation/bin"
      "/opt/cmdline-tools/bin"
      "/opt/Telegram"

      "$HOME/.local/bin"
      "$HOME/.yarn/bin"
      "$HOME/.cargo/bin"
      "$HOME/.emacs.d/bin"
      "$HOME/.pub-cache/bin"
      "$HOME/.nix-profile/bin"
      "$HOME/.platformio/penv/bin"
      "$HOME/Projects/main/templates"

      "$GOPATH/bin"
      "$ANDROID_HOME/emulator"
      "$ANDROID_HOME/tools/bin"
      "$ANDROID_HOME/cmdline-tools/bin"
      "$PNPM_HOME"
    ];

    home.shellAliases = {
      sudo = "sudo ";  # Hack to run alias w/sudo: https://askubuntu.com/a/22043/669216 (does not work in fish)
      snvim = "sudo -E nvim";
      nv = "kitty-nopad nvim";
      snv = "sudo -E kitty-nopad nvim";
      hc = "herbstclient";
      tree = "tree -C";
      jl = "jupyter-lab --notebook-dir=/home/animesh/Projects/GeneralPurpose/JupyterLab";
      ":q" = "exit";
      lsblk = "lsblk -o NAME,MODEL,MAJ:MIN,TRAN,FSTYPE,RM,SIZE,RO,LABEL,MOUNTPOINTS";
      macros = "cpp -dM /dev/null";

      audio = "inxi -A";
      battery = "inxi -B -xxx";
      bluetooth = "inxi -E";
      fonts = "kitty +list-fonts";
      graphics = "inxi -G";
      pci = "sudo inxi --slots";
      process = "inxi --processes";
      partitions = "inxi -P";
      repos = "inxi -r";
      sockets = "ss -lp";
      system = "inxi -Fazy";
      usb = "inxi -J";
      wifi = "inxi -n";
    };

    programs.fish.shellAbbrs = {
      nqq = "notepadqq";
      pmem = "sudo ps_mem";

      xi = "sudo xbps-install";
      xp = "sudo xbps-pkgdb";
      xq = "xbps-query -Rs";
      xf = "xbps-query -Rf";
      xx = "xbps-query -Rx";
      xX = "xbps-query -RX";
      xr = "sudo xbps-remove -R";

      ng = "nix-collect-garbage -d";
      no = "nix store optimise";
      nr = "nix registry list";
      npi = "nix profile install";
      npr = "nix profile remove";
      nph = "nix profile history";
      nproll = "nix profile rollback --to";
    };

    programs.brave.commandLineArgs = [
      "--force-dark-mode"
      "--enable-features=VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization,TouchpadOverscrollHistoryNavigation,WebUIDarkMode"
      "--enable-zero-copy"
      "--use-gl=desktop"
      "--ignore-gpu-blocklist"
      "--enable-oop-rasterization"
      "--enable-raw-draw"
      "--enable-gpu-compositing"
      "--enable-gpu-rasterization"
      "--enable-native-gpu-memory-buffers"
      "--use-vulkan"
      "--disable-features=UseChromeOSDirectVideoDecoder"
      "--disable-sync-preferences"
      "--force-device-scale-factor=${toString config.united.desktop.xorg.scale}"
      "--password-store=basic"
    ];

    environment.etc."cron.weekly/fstrim" = {
      executable = true;
      text = "fstrim / || zpool trim zroot";
    };


    environment.etc."cron.weekly/nix-store-optimise" = {
      executable = true;
      text = "nix store optimise";
    };

    environment.etc."acpi/handler.sh" = {
      executable = true;
      text = ''
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
      '';
    };

    environment.etc."auto-cpufreq.conf".text = ''
      [charger]
      governor = powersave
      turbo = never

      [battery]
      governor = powersave
      turbo = never
    '';
  };
}
