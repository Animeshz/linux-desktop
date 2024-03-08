{ pkgs, lib, config, ... }:

let
  cfg = config.united.editors.emacs;
in
with lib;
{
  options.united.editors.emacs = {
    enable = mkEnableOption "emacs";
    config = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs29;

      extraPackages = epkgs: with epkgs; with pkgs; [
        custom.emacs-pcre
        custom.emacs-chdir
      ];
    };

    home.activation.cloneEmacsConfig = mkIf (cfg.config != null)
      (lib.home-manager.hm.dag.entryAfter [ "linkGeneration" ] ''
        emacs_dir="${config.home.homeDirectory}/.emacs.d"
        [ -d "$emacs_dir" ] || $DRY_RUN_CMD ${pkgs.git}/bin/git clone ${cfg.config} "$emacs_dir"
      '');
  };
}
