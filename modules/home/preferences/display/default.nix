{ pkgs, lib, config, ... }:

with lib;
with lib.internal;
let
  cfg = config.preferences.display;
in {
  imports = [
    ./xorg.nix
    ./herbstluftwm.nix
    ./eww.nix
  ];

  options = {
    preferences.display = {
      enable = mkEnableOption "Enable display management or not";

      hidpi.enable = mkEnableOption "Enable HiDPI settings or not";
      scale = mkOption { type = types.nullOr types.float; };
      cursorSize = mkOption { type = types.nullOr types.int; };
      autoRepeat = {
        delay = mkOption { type = types.int; default = 660; };
        rate = mkOption { type = types.int; default = 25; };
      };

      wallpaper = mkOption { type = types.nullOr types.path; };
      fonts = mkOption { type = types.listOf types.package; default = []; };

      windowManagers = {
        modKey = mkOption { type = types.str; default = "Mod4"; };  # super key
        moveKey = mkOption { type = types.str; default = "Shift"; };
        resizeKey = mkOption { type = types.str; default = "Ctrl"; };

        extraKeybinds = mkOption {
          type = selectorFunctionOf (types.attrsOf types.str);
          default = _: {};
        };

        extraMousebinds = mkOption {
          type = selectorFunctionOf (types.attrsOf types.str);
          default = _: {};
        };
      };

      bars = {
        height = mkOption { type = types.int; };
      };
    };
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = cfg.fonts;

    # Required to use gtk/dconf options from home-manager
    puppet.ral = {
      package.dconf = { ensure = "installed"; };
    };
  };
}
