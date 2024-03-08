{ config, lib, pkgs, ... }:

let
  cfg = config.united.cli.starship;
in
with lib;
{
  options.united.cli.starship.enable = mkEnableOption "starship";

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;

      settings = {
        command_timeout = 1000;

        line_break.disabled = true;
        package.disabled = true;

        cmd_duration = {
          format = "took [$duration]($style) ";
          min_time = 2000;
        };

        character = {
          success_symbol = "[>](bold red)[>](bold yellow)[>](bold green)";
          error_symbol = "[✗✗✗](bold red)";
        };

        directory = {
          truncation_length = 5;
          format = "[ ](bold cyan) [$path]($style)[$lock_symbol]($lock_style) ";
          style = "bold cyan";
          read_only = "🔒";
          read_only_style= "bold red";
        };
      };
    };
  };
}
