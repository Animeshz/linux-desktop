{ pkgs, lib, config, ... }:

let
  cfg = config.apps.emacs;
in
with lib;
{
  options = {
    apps.emacs.enable = mkEnableOption "Install and configure emacs";
    apps.emacs.configRepo = mkOption {
      type = types.str;
      default = "https://github.com/Animeshz/.emacs.d";
    };
  };

  config = mkIf cfg.enable {
    home.activation.cloneEmacsD = lib.home-manager.hm.dag.entryAfter [ "linkGeneration" ] ''
      emacs_dir="${config.home.homeDirectory}/.emacs.d"
      [ -d "$emacs_dir" ] || $DRY_RUN_CMD ${pkgs.git}/bin/git clone ${cfg.configRepo} "$emacs_dir"
    '';

    programs.emacs = {
      enable = true;
      extraPackages = epkgs: with epkgs; with pkgs; [
        custom.emacs-pcre
        custom.emacs-chdir
      ];
    };
  };
}
