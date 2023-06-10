{ pkgs, lib, config, ... }:

let
  cfg = config.apps.kitty;
in
with lib;
{
  options = {
    apps.kitty.enable = mkEnableOption "Install and configure kitty";
  };

  config = mkIf cfg.enable {
    programs.kitty.enable = true;

    xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;
    xdg.configFile."kitty/themes" = {
      source = ./themes;
      recursive = true;
    };
  };
}