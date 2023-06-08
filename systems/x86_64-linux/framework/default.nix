{ lib, ... }:

{
  system.stateVersion = "23.05";

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/bb4d72db-5f94-4390-b02c-a4de5a73235f";
      fsType = "ext4";
    };

  boot.loader.grub.devices = [ "/dev/nvme0n1" ];
  boot.loader.grub.efiSupport = true;
}
