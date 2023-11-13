{ pkgs, lib, config, ... }:

let
  cfg = config.apps.cli.just;
in
with lib;
{
  options = {
    apps.cli.just.enable = mkEnableOption "Install and configure just";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.just ];

    programs.fish.shellInit = ''
      ${pkgs.just}/bin/just --completions fish | source
    '';
  };
}
