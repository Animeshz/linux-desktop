{ pkgs, lib, config, ... }:

let
  cfg = config.apps.cli.kitty;
in
with lib;
{
  options = {
    apps.cli.kitty.enable = mkEnableOption "Install and configure kitty";
  };

  config = mkIf cfg.enable {
    #programs.kitty.enable = true;   # TODO: Temporarily commented because of GLFX error

    xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;
    xdg.configFile."kitty/themes" = {
      source = ./themes;
      recursive = true;
    };
  };
}
