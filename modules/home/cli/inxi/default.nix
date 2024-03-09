{ config, lib, pkgs, ... }:

let
  cfg = config.united.cli.inxi;
in
with lib;
{
  options.united.cli.inxi.enable = mkEnableOption "inxi";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      inxi
    ];

    home.shellAliases = {
      audio = "inxi -A";
      battery = "inxi -B -xxx";
      bluetooth = "inxi -E";
      graphics = "inxi -G";
      macros = "cpp -dM /dev/null";
      pci = "sudo inxi --slots";
      process = "inxi --processes";
      partitions = "inxi -P";
      repos = "inxi -r";
      sockets = "ss -lp";
      system = "inxi -Fazy";
      usb = "inxi -J";
      wifi = "inxi -n";
    };
  };
}

