{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.apps.network.network-manager;
in {
  options = {
    apps.network.network-manager = {
      enable = mkEnableOption "Setup network manager";

      applet.enable = mkEnableOption "Enable network-manager applet service";
      iwd.enable = mkEnableOption "Use iwd backend";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.etc."NetworkManager/conf.d/iwd.conf".text = mkIf cfg.iwd.enable ''
        [device]
        wifi.backend=iwd
      '';

      # TODO: void-specific
      environment.etc."sv/network-manager-applet/run" = {
        executable = true;
        text = ''
          #!/bin/sh
          ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator 2>&1
        '';
      };
    })
    {
      puppet.ral = {
        package.NetworkManager = { ensure = "installed"; };
        service.NetworkManager = lib.home-manager.hm.dag.entryAfter [ "package.NetworkManager" ]
          { ensure = if cfg.enable then "running" else "stopped"; };

        service.network-manager-applet = { ensure = if cfg.enable && cfg.applet.enable then "running" else "stopped"; };
      };
    }
  ];

}
