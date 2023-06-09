{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    flake-utils.url = "github:numtide/flake-utils";

    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
    flake-utils-plus.inputs.flake-utils.follows = "flake-utils";

    snowfall-lib.url = "github:snowfallorg/lib/feat/home-manager";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";
    snowfall-lib.inputs.flake-utils-plus.follows = "flake-utils-plus";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # system-manager.url = "github:numtide/system-manager";
    system-manager.url = "github:Animeshz/system-manager/system_packages";
    system-manager.inputs.nixpkgs.follows = "nixpkgs";
    system-manager.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      package-namespace = "custom";

      systemConfigs.framework = inputs.system-manager.lib.makeSystemConfig {
        modules = [
          ./systems/x86_64-linux/framework/default.nix
       ];
      };
    };
}
