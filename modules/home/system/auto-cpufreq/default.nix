{ config, lib, ... }:

with lib;
let
  cfg = config.united.system.auto-cpufreq;
in {
  options.united.system.auto-cpufreq.enable = mkEnableOption "auto-cpufreq";

  config = mkIf cfg.enable {
    environment.etc."auto-cpufreq.conf".text = ''
      [charger]
      governor = powersave
      energy_performance_preference = power
      turbo = never

      [battery]
      governor = powersave
      energy_performance_preference = power
      turbo = never
    '';
  };
}

