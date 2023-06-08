{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    snowfall-lib.url = "github:snowfallorg/lib/feat/home-manager";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
    };
}
