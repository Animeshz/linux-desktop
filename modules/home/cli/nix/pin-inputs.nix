{ config, lib, inputs, ... }:

let
  cfg = config.united.cli.nix;
in
with lib;
{
  options.united.cli.nix.pinInputs = mkEnableOption "pin the flake inputs";

  config = mkIf cfg.pinInputs {
    nix.registry.nixpkgs.flake = inputs.nixpkgs;                  # pin for new command syntax
    home.sessionVariables.NIX_PATH = "nixpkgs=${inputs.nixpkgs}"; # pin for old-command syntax

    # prevent flake inputs from being garbage-collected until this profile is activated
    xdg.configFile."nix-flake-inputs".text = lib.concatStringsSep "\n" (map (ip: ip.outPath) (lib.attrValues inputs));
  };
}
