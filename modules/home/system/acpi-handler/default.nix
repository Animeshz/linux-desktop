{ config, lib, ... }:

with lib;
let
  cfg = config.united.system.acpi-handler;
in {
  options.united.system.acpi-handler.enable = mkEnableOption "sysctl";

  config = mkIf cfg.enable {
    environment.etc."acpi/handler.sh" = {
      executable = true;
      source = ./files/acpi-handler.sh;
    };
  };
}
