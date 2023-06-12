{ pkgs, lib, ... }:

with lib;
with lib.internal;
{
  home.stateVersion = "23.05";
  nix.extraOptions = "max-jobs = auto";

  apps.emacs = enabled;
  apps.cli.kitty = enabled;
  apps.cli.starship = enabled;

  apps.git = {
    user = "Animesh Sahu";
    email = "animeshsahu19@yahoo.com";
    signingkey = "541C03D55917185E";
  };

  puppet = {
    enable = true;
    ral = with lib.hm.dag; {
      # service.adb = entryAnywhere { ensure = "stopped"; };
      # service.sshd = entryAnywhere { ensure = "stopped"; };
      # service.docker = entryAnywhere { ensure = "running"; };
    };
  };

  display = {
    enable = true;
    hidpi = enabled;
    scale = 1.5;
    cursorSize = 50;
    autoRepeat.delay = 300;
    autoRepeat.rate = 50;

    xorg.enableHost = true;
    windowManagers.herbstluftwm = enabled;
    bars.eww = enabled;
    wallpaper = ./wallpaper.jpg;

    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
      noto-fonts
      noto-fonts-emoji
      unifont
    ];
  };

  virtualization.vagrant = {
    enable = true;
    libvirtHost = enabled;
    virtualboxHost = enabled;
  };

  # TODO: Move most of these variables to their modules (declutter this file).
  home.sessionVariables = {
    EDITOR = "nvim";
    LIBVA_DRIVER_NAME = "iHD";
    PKG_CONFIG_PATH = "/usr/lib/pkgconfig";
    CHROME_EXECUTABLE = "/bin/brave-browser-stable";  # for flutter
    ANT_HOME = "/usr/share/apache-ant";               # for jar builds (mainly emuArm)
    GOROOT = "/usr/lib/go";
    GOPATH = "$HOME/.go";
    ANDROID_HOME = "$HOME/.android-data/Sdk";
    NDK_HOME = "$HOME/.android-data/Ndk";
    PNPM_HOME = "/home/animesh/.local/share/pnpm";
  };

  home.dynamicSessionVariables = {
    RUSTC_WRAPPER = "$(command -v sccache 2>/dev/null)";
    PATH = "$PATH:$(fd -td -d1 . ~/.scripts 2>/dev/null || find ~/.scripts -type d -maxdepth 1):$(gem env 2>/dev/null | grep 'EXECUTABLE DIRECTORY' | sed --quiet \"s/.*EXECUTABLE DIRECTORY: \(.*\)/\1/p\")/bin";
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
    "$PNPM_HOME
    "
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

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.fish = {
    enable = true;

    shellAbbrs = {
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

    plugins = [
      (with pkgs.sources.nix-env-fish; { name = pname; inherit src; })
      (with pkgs.sources.nvm-fish; { name = pname; inherit src; })
    ];
  };

  programs.brave = {
    enable = true;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; }  # Bitwarden
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }  # Dark Reader
      { id = "jiaopdjbehhjgokpphdfgmapkobbnmjp"; }  # Youtube-shorts block
      { id = "omkfmpieigblcllmkgbflkikinpkodlk"; }  # enhanced-h264ify
      { id = "jghecgabfgfdldnmbfkhmffcabddioke"; }  # Volume Master
      { id = "bpelaihoicobbkgmhcbikncnpacdbknn"; }  # Chrome Regex Search
      { id = "jabopobgcpjmedljpbcaablpmlmfcogm"; }  # WhatFont
      { id = "ckkdlimhmcjmikdlpkmbgfkaikojcbjk"; }  # Markdown Viewer
      # { id = "gpcahfpgfhbghoplpdmjomdemaphldpl";    # Multi-Touch Pinch Zoom
      #   crxPath = ./multi-touch-pinch-zoom/extension.crx;
      #   version = "0.95";
      # }
    ];
    commandLineArgs = [
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
