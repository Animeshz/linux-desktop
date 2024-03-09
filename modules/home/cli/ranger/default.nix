{ config, lib, pkgs, ... }:

let
  cfg = config.united.cli.ranger;
in
with lib;
{
  options.united.cli.ranger.enable = mkEnableOption "ranger";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ranger
      poppler_utils
    ];

    home.sessionVariables.RANGER_LOAD_DEFAULT_RC = "false";
  };
}

