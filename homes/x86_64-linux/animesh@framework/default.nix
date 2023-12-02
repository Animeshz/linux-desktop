{ config, pkgs, lib, ... }:

with lib;
with lib.internal;
{
  snowfallorg.user.enable = true;
  home.stateVersion = "23.05";
  nix.extraOptions = "max-jobs = auto";

  preferences = {
    nix.pinInputs = true;
    nix.setupComma = true;
  };

  puppet = enabled;

  apps.cli.just = enabled;
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

  apps.dev.git = {
    enable = true;
    user = "Animesh Sahu";
    email = "animeshsahu19@yahoo.com";
    signingkey = "541C03D55917185E";
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

  # apps.virt.vagrant = {
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

  preferences.display = {
    enable = true;
    hidpi = enabled;
    scale = 1.5;
    cursorSize = 50;
    autoRepeat.delay = 300;
    autoRepeat.rate = 50;

    xorg.enableHost = true;
    wallpaper = ./wallpaper.jpg;

    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
      noto-fonts
      noto-fonts-emoji
      unifont
      custom.phosphor-icons
    ];

    bars = {
      eww = enabled;
    };

    windowManagers = {
      herbstluftwm = enabled;

      extraKeybinds = klib: klib.withModKey {
        m =       klib.launch "${config.programs.emacs.finalPackage}/bin/emacs";
        # b =       klib.launch "${config.programs.brave.package}/bin/brave";  # TODO: https://github.com/nix-community/home-manager/issues/4723
        b = klib.launch "brave || brave-browser-stable";
        slash =   klib.launch "${pkgs.logseq}/bin/logseq";
        t =       klib.launch "sh -c '\"$(command -v pwd-launch || printf eval)\" ${config.programs.kitty.package}/bin/kitty'";
        Return =  klib.launch "sh -c '\"$(command -v pwd-launch || printf eval)\" ${config.programs.kitty.package}/bin/kitty'";

        Shift-p = klib.launch "sh -c 'active-window-pid | xclip -sel clip'";
        Shift-c = klib.launch "sh -c 'printf \"document.querySelector(\"video\").playbackRate = 3\" | xclip -sel clip'";

        # Backups
        Shift-t = klib.launch "xterm";
        Shift-b = klib.launch "brave || brave-browser-stable";
      } // {
        Ctrl-Alt-t = klib.launch "sh -c '\"$(command -v pwd-launch || printf eval)\" ${config.programs.kitty.package}/bin/kitty'";
        Ctrl-space = klib.launch "sh -c '${pkgs.ulauncher}/bin/ulauncher-toggle || ${pkgs.ulauncher}/bin/ulauncher'";
        Alt-space = klib.launch "${pkgs.rofi}/bin/rofi -show run -kb-cancel Super-space,Alt-space,Escape -matching fuzzy -sorting-method fzf -sort";
	# TODO: customize rofi and remove ulauncher

        # These depends on dbus-session at local user, rest of them defined in /etc/acpi/handler.sh
        XF86AudioPlay = klib.launch "mutoggle";
        XF86AudioStop = klib.launch "mutoggle";
        XF86AudioPrev = klib.launch "muprv";
        XF86AudioNext = klib.launch "munxt";
      };
    };
  };
}
