{ pkgs, lib, ... }:

with lib;
with lib.internal;
{
  snowfallorg.user.enable = true;
  home.stateVersion = "23.05";
  nix.extraOptions = "max-jobs = auto";

  preferences = {
    nix.setupComma = true;
    nix.pinInputs = true;
  };

  apps.cli.kitty = enabled;
  apps.cli.starship = enabled;

  programs.emacs = {
    enable = true;
    config = "https://github.com/Animeshz/.emacs.d";

    extraPackages = epkgs: with epkgs; with pkgs; [
      custom.emacs-pcre
      custom.emacs-chdir
    ];
  };

  apps.cli.ranger = {
    enable = true;
    previewImages = true;
    previewPdfs = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.fish = {
    enable = true;

    plugins = [
      (with pkgs.nvfetcher-sources.nix-fish; { name = pname; inherit src; })
      (with pkgs.nvfetcher-sources.nvm-fish; { name = pname; inherit src; })
    ];
  };

  programs.bat = enabled;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  apps.git = {
    enable = true;
    user = "Animesh Sahu";
    email = "animeshsahu19@yahoo.com";
    signingkey = "541C03D55917185E";
  };

  puppet = enabled;

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

  # Non-Systemd not working...
  # dconf = {
  #   enable = true;
  #   settings = with lib.home-manager.hm.gvariant; {
  #     "org/gtk/settings/file-chooser" = {
  #       window-position = mkTuple [ 100 100 ];
  #       window-size = mkTuple [ 500 500 ];
  #     };
  #   };
  # };

  # virtualization.vagrant = {
  #   enable = true;
  #   libvirtHost = enabled;
  #   virtualboxHost = enabled;
  # };

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
    ];
  };

  # General packages which require zero-to-no configurations
  # They _are_ general and not project-specific
  home.packages = with pkgs; [
    # archives
    p7zip

    # monitoring
    btop
    du-dust
    inxi
    tree

    # utils
    fd
    ffmpeg
    maim
    moreutils
    ripgrep
    wget
    xclip

    # extras
    logseq
    nushell
    pandoc
    xdg-utils
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "brave-browser.desktop";
      "inode/directory" = "ranger.desktop";
      "text/plain" = "emacs.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/mailto" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
      "x-scheme-handler/element" = "element-desktop.desktop";
      "x-scheme-handler/irc" = "element-desktop.desktop";
      "x-scheme-handler/logseq" = "logseq.desktop";
    };
    # Default browser is set with $BROWSER in misc.settings for now
  };

  # TODO: Move most of hardcoded personal better defaults (preferences) at misc.settings
  # to their individual modules its currently too unmanaged...
  misc.settings.apply = true;
}
