{ config, lib, inputs, ... }:

let
  cfg = config.preferences.nix;
in
with lib;
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  options = {
    preferences.nix.setupComma = mkEnableOption "enable nix-community/comma";
    preferences.nix.pinInputs = mkEnableOption "pin the flake inputs";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.setupComma {
      programs.nix-index-database.comma.enable = true;
      programs.nix-index.enable = false;  # don't control command-not-found
    })
    (lib.mkIf cfg.pinInputs {
      nix.registry.nixpkgs.flake = inputs.nixpkgs;                  # pin for new command syntax
      home.sessionVariables.NIX_PATH = "nixpkgs=${inputs.nixpkgs}"; # pin for old-command syntax

      # prevent flake inputs from being garbage-collected until this profile is activated
      xdg.configFile."nix-flake-inputs".text = lib.concatStringsSep "\n" (map (ip: ip.outPath) (lib.attrValues inputs));
    })
  ];
}
