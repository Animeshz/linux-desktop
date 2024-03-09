{ config, lib, ... }:

with lib;
let
  cfg = config.united.cli.bat;
in {
  options.united.cli.bat.enable = mkEnableOption "bat";

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };

    home.sessionVariables = {
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
    };
  };
}
