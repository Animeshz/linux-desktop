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
      EDITOR = "nvim";
      LIBVA_DRIVER_NAME = "iHD";
      PKG_CONFIG_PATH = "/usr/lib/pkgconfig";
      BROWSER = "${config.programs.brave.package}/bin/brave";            # for xdg-open
      CHROME_EXECUTABLE = "${config.programs.brave.package}/bin/brave";  # for flutter
      ANT_HOME = "/usr/share/apache-ant";                                # for jar builds (mainly emuArm)
      GOROOT = "/usr/lib/go";
      GOPATH = "$HOME/.go";
      ANDROID_HOME = "$HOME/.android-data/Sdk";
      NDK_HOME = "$HOME/.android-data/Ndk";
      PNPM_HOME = "/home/animesh/.local/share/pnpm";
      RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
      PATH = "$PATH:$(${pkgs.ruby}/bin/gem env 2>/dev/null | ${pkgs.coreutils}/bin/grep 'EXECUTABLE DIRECTORY' | ${pkgs.gnused}/bin/sed --quiet \"s/.*EXECUTABLE DIRECTORY: \(.*\)/\1/p\"):$(${pkgs.fd}/bin/fd -td -d1 . ~/.scripts 2>/dev/null | tr \\n :)";
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
      "$ANDROID_HOME/cmdline-tools/latest/bin"
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
      battery = "inxi -B";
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
      "--force-device-scale-factor=1.5"
      "--password-store=basic"
    ];
  };
}
