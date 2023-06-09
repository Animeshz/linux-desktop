{ pkgs, lib, ... }:

with lib;
with lib.internal;
{
  home.stateVersion = "23.05";
  nix.extraOptions = "max-jobs = auto";

  # TODO: Setup kitty starship fish
  apps.emacs = enabled;

  apps.git = {
    user = "Animesh Sahu";
    email = "animeshsahu19@yahoo.com";
    signingkey = "541C03D55917185E";
  };

  display = {
    hidpi = enabled;
    scale = 1.5;
    cursorSize = 50;
    autoRepeat.delay = 300;
    autoRepeat.rate = 50;

    windowManagers.herbstluftwm = enabled;
    bars.eww = enabled;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
      noto-fonts
      noto-fonts-emoji
      unifont
    ];

    # TODO: install gfx drivers with enable.
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
