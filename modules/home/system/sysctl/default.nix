{ config, lib, ... }:

with lib;
let
  cfg = config.united.system.sysctl;
in {
  options.united.system.sysctl.enable = mkEnableOption "sysctl";

  config = mkIf cfg.enable {
    environment.etc."sysctl.conf".text = ''
      vm.swappiness=10
      dev.i915.perf_stream_paranoid=0
    '';
  };
}
