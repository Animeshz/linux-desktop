{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.united.apps.brave;
in {
  options.united.apps.brave.enable = mkEnableOption "brave";

  config = mkIf cfg.enable {
    home.sessionVariables = {
      BROWSER = "brave";            # for xdg-open
      CHROME_EXECUTABLE = "brave";  # for flutter
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
        "--force-device-scale-factor=${toString config.united.desktop.xorg.scale}"
        "--password-store=basic"
      ];
    };
  };
}
