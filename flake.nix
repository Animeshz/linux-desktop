{
  description = "My system configuration";

  inputs = {
    # Until Ongoing PR merges on a stable branch: https://github.com/NixOS/nixpkgs/pull/237917
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs.url = "github:Animeshz/nixpkgs/nixos-23.05";

    snowfall-lib.url = "github:snowfallorg/lib/feat/home-manager";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      channels-config.allowUnfree = true;
      package-namespace = "custom";
    };
}
