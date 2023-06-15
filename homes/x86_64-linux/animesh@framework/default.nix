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

  # virtualization.vagrant = {
  #   enable = true;
  #   libvirtHost = enabled;
  #   virtualboxHost = enabled;
  # };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.fish = {
    enable = true;

    plugins = [
      (with pkgs.nvfetcher-sources.nix-env-fish; { name = pname; inherit src; })
      (with pkgs.nvfetcher-sources.nvm-fish; { name = pname; inherit src; })
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
    ];
  };

  home.packages = with pkgs; [
    btop
    du-dust
    fd
    maim
    moreutils
    p7zip
    ripgrep
    tree
    xclip
    xdg-utils
    xterm
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "brave-browser.desktop";
      "inode/directory" = "ranger.desktop";
      "text/plain" = "emacs.desktop";
    };
    associations.added = {
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/mailto" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
      "x-scheme-handler/element" = "element-desktop.desktop";
      "x-scheme-handler/irc" = "element-desktop.desktop";
    };
    # Default browser is set with $BROWSER in misc.settings for now
  };

  # TODO: Move most of hardcoded personal better defaults (preferences) at misc.settings
  # to their individual modules its currently too unmanaged...
  misc.settings.apply = true;
}
