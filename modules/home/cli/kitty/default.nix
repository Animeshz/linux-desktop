{ config, lib, pkgs, ... }:

let
  cfg = config.united.cli.kitty;
in
with lib;
{
  options.united.cli.kitty.enable = mkEnableOption "kitty";

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      package = lib.internal.nixGLWrapIntel pkgs pkgs.kitty;
    };

    xdg.configFile."kitty" = {
      source = ./files;
      recursive = true;
    };

    home.shellAliases.fonts = "kitty +list-fonts";
  };
}
