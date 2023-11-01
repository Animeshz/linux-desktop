{ pkgs, lib, config, ... }:

let
  cfg = config.virtualization.vagrant;
in
with lib;
with lib.home-manager;
{
  options = {
    virtualization.vagrant.enable = mkEnableOption "Install and configure vagrant";

    # host because: dkms integration works better on host
    virtualization.vagrant.libvirtHost.enable = mkEnableOption "vagrant libvirt support";
    virtualization.vagrant.virtualboxHost.enable = mkEnableOption "vagrant virtualbox support";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.vagrant ];

    puppet.ral = with lib.home-manager.hm.dag; {
      package.libvirt = mkIf cfg.libvirtHost.enable (entryAnywhere { ensure = "present"; });
      package.dbus = mkIf cfg.libvirtHost.enable (entryBefore ["package.libvirt"] { ensure = "present"; });
      service.dbus = mkIf cfg.libvirtHost.enable (entryAfter ["package.dbus"] { ensure = "running"; });
      service.libvirtd = mkIf cfg.libvirtHost.enable (entryAfter ["service.dbus"] { ensure = "running"; });
      service.virtlockd = mkIf cfg.libvirtHost.enable (entryAfter ["service.dbus"] { ensure = "running"; });
      service.virtlogd = mkIf cfg.libvirtHost.enable (entryAfter ["service.dbus"] { ensure = "running"; });
      user."${config.home.username}" = mkIf cfg.libvirtHost.enable (entryAfter ["package.libvirt"] { groups = "libvirt"; });

      package.virtualbox-ose = mkIf cfg.virtualboxHost.enable (entryAnywhere { ensure = "present"; });
    };
  };
}