{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.preferences.display;
in {
  imports = [
    ./xorg.nix
    ./windowManagers.nix
  ];

  options = {
    preferences.display.enable = mkEnableOption "Enable display management or not";

    preferences.display.hidpi.enable = mkEnableOption "Enable HiDPI settings or not";
    preferences.display.scale = mkOption { type = types.nullOr types.float; };
    preferences.display.cursorSize = mkOption { type = types.nullOr types.int; };
    preferences.display.autoRepeat = {
      delay = mkOption { type = types.int; default = 660; };
      rate = mkOption { type = types.int; default = 25; };
    };

    preferences.display.wallpaper = mkOption { type = types.nullOr types.path; };
    preferences.display.fonts = mkOption { type = types.listOf types.package; default = []; };
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = cfg.fonts;
  };
}
