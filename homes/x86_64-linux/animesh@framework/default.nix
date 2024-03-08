{ config, pkgs, lib, ... }:

with lib;
with lib.internal;
{
  snowfallorg.user.enable = true;
  home.stateVersion = "23.05";

  united = {
    cli = {
      kitty.enable = true;
      fish.enable = true;
      starship.enable = true;
      just.enable = true;
      ranger.enable = true;

      nix.pinInputs = true;
      nix.setupComma = true;

      git = {
        enable = true;
        user = "Animesh Sahu";
        email = "animeshsahu19@yahoo.com";
        signingkey = "541C03D55917185E";
      };
    };

    desktop = {
      herbstluftwm.enable = true;
      eww.enable = true;

      fonts = with pkgs; [
        (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
        noto-fonts
        noto-fonts-emoji
        unifont
        custom.phosphor-icons
      ];

      xorg = {
        enable = true;
        hidpi.enable = true;
        scale = 1.5;
        cursorSize = 50;
        autoRepeat.delay = 300;
        autoRepeat.rate = 50;

        xorg.enableHost = true;
        wallpaper = ./wallpaper.jpg;
      };
    };

    editors = {
      nvim.enable = true;

      emacs = {
        enable = true;
        config = "https://github.com/Animeshz/.emacs.d";
      };
    };
  };

  puppet.enable = true;

  # direct home-manager modules
  programs = {
    # TODO: make bat pager module
    bat.enable = true;

    bash = {
      enable = true;
      enableCompletion = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  dconf = {
    enable = true;
    settings = with lib.home-manager.hm.gvariant; {
      "org/gtk/settings/file-chooser" = {
        window-position = mkTuple [ 100 100 ];
        window-size = mkTuple [ 500 500 ];
      };
    };
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
    ulauncher
    rofi
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

  environment.etc."sysctl.conf".text = ''
    vm.swappiness=10
    dev.i915.perf_stream_paranoid=0
  '';
}
