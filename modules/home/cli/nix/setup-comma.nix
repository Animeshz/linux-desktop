{ config, lib, inputs, ... }:

let
  cfg = config.united.cli.nix;
in
with lib;
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  options.united.cli.nix.setupComma = mkEnableOption "nix-community/comma";

  config = mkIf cfg.setupComma {
    programs.nix-index-database.comma.enable = true;
    programs.nix-index.enable = false;  # don't control command-not-found
  };
}
