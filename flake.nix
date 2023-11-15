{
  description = "My system configuration";

  inputs = {
    # Until Ongoing PR merges on a stable branch: https://github.com/NixOS/nixpkgs/pull/237917
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:Animeshz/nixpkgs/nixos-23.05";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    eww.url = "github:ralismark/eww/tray-3";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      channels-config.allowUnfree = true;
      package-namespace = "custom";

      overlays = [
        inputs.nixgl.overlay
      ];

      # Option Reference: https://github.com/snowfallorg/lib/tree/main/snowfall-lib/flake/default.nix#L99
    };
}
