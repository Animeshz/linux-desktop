{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.united.desktop.fonts;
in {
  options.united.desktop.fonts = mkOption { type = types.listOf types.package; default = []; };

  config = mkIf (cfg != []) {
    fonts.fontconfig.enable = true;
    home.packages = cfg;
  };
}
