{ config, lib, ... }:

with lib;
let
  cfg = config.united.cli.nix;
in {
  imports = [
    ./pin-inputs.nix
    ./setup-comma.nix
  ];

  options.united.cli.nix.enable = mkEnableOption "nix";

  config = mkIf cfg.enable {
    nix.extraOptions = "max-jobs = auto";

    environment.etc."cron.weekly/nix-store-optimise" = {
      executable = true;
      text = "nix store optimise";
    };
  };
}
