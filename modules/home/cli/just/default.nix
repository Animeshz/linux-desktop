{ config, lib, pkgs, ... }:

let
  cfg = config.united.cli.just;
in
with lib;
{
  options.united.cli.just.enable = mkEnableOption "just";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.just ];

    programs.fish.shellInit = ''
      ${pkgs.just}/bin/just --completions fish | source
    '';
  };
}
