{ pkgs, lib, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # environment.etc."" = {
  #   source = ./etc;
  #   # recursive = true;
  # };
  # environment.systemPackages = [ pkgs.exa ];
}
