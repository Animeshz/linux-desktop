{ config, lib, ... }:

with lib;
let
  cfg = config.united.system.fstrim;
in {
  options.united.system.fstrim.enable = mkEnableOption "fstrim";

  config = mkIf cfg.enable {
    environment.etc."cron.weekly/fstrim" = {
      executable = true;
      text = "fstrim / || zpool trim zroot";
    };
  };
}
