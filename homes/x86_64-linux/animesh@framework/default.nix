{ inputs, pkgs, lib, ... }:

with lib;
with lib.internal;
{
  snowfallorg.user.enable = true;
  home.stateVersion = "23.05";
  nix.extraOptions = "max-jobs = auto";

  apps.emacs = enabled;
  apps.cli.kitty = enabled;
  apps.cli.starship = enabled;

  apps.cli.ranger = {
    enable = true;
    previewImages = true;
    previewPdfs = true;
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

  dconf = {
    enable = true;
    settings = with lib.home-manager.hm.gvariant; {
      "org/gtk/settings/file-chooser" = {
        window-position = mkTuple [ 100 100 ];
        window-size = mkTuple [ 500 500 ];
      };
    };
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

  # General packages which require zero-to-no configurations
  # They _are_ general and not project-specific
  home.packages = with pkgs; [
    bat
    btop
    du-dust
    fd
    ffmpeg
    logseq
    inxi
    maim
    moreutils
    nushell
    p7zip
    pandoc
    ripgrep
    tree
    wget
    xclip
    xdg-utils
    xterm
    zoxide
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
      "x-scheme-handler/logseq" = "logseq.desktop";
    };
    # Default browser is set with $BROWSER in misc.settings for now
  };

  # TODO: Move most of hardcoded personal better defaults (preferences) at misc.settings
  # to their individual modules its currently too unmanaged...
  misc.settings.apply = true;

  # Realise this so flake inputs are not garbage-collected until this profile is activated
  xdg.configFile."nix-flake-inputs".text = lib.concatStringsSep "\n" (map (ip: ip.outPath) (lib.attrValues inputs));
}
