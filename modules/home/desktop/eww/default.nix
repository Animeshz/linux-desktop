{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.united.desktop.eww;
in
{
  options.united.desktop.eww.enable = mkEnableOption "eww";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.eww ];
  };
}
