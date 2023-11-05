{ pkgs, lib, config, ... }:

with lib;
with lib.internal;
let
  cfg = config.preferences.display;
in {
  imports = [
    ./herbstluftwm.nix
  ];

  options = {
    preferences.display.windowManagers = {
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

    preferences.display.bars = {
      eww.enable = mkEnableOption "Setup eww";
    };
  };

  config = {
    home.packages = [ pkgs.eww ];

    xdg.configFile."eww" = mkIf cfg.bars.eww.enable {
      source = ./eww;
      recursive = true;
      executable = true;
    };
  };
}
