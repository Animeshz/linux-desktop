{ pkgs, lib, config, ... }:

let
  cfg = config.united.languages.ruby;
in
with lib;
with lib.home-manager;
{
  options.united.languages.ruby = {
    enable = mkEnableOption "ruby";

    gems = mkOption {
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
