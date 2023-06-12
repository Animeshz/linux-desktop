{ pkgs, lib, config, ... }:

let
  cfg = config.apps.cli.starship;
in
with lib;
{
  options = {
    apps.cli.starship.enable = mkEnableOption "Install and configure starship";
  };

  config = {
    programs.starship = {
      enable = cfg.enable;

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