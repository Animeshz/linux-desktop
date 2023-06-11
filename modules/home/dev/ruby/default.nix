{ pkgs, lib, config, ... }:

let
  cfg = config.dev.ruby;
in
with lib;
with lib.home-manager;
{
  options = {
    dev.ruby.enable = mkEnableOption "Install and configure ruby dev environment";

    dev.ruby.gems = mkOption {
      default = self: [ ];
      type = hm.types.selectorFunction;
      defaultText = "epkgs: []";
      example = literalExpression "epkgs: [ epkgs.puppet epkgs.rufo ]";
      description = ''
        Gems that should be available to Ruby. To get a list of
        available packages run:
        <command>nix-env -f '&lt;nixpkgs&gt;' -qaP -A rubyPackages</command>.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      let
        pkg = pkgs.ruby.withPackages (epkgs: cfg.gems epkgs);
      in [ pkg ];
  };
}