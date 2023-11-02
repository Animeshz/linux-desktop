{ pkgs, lib, config, ... }:

with lib;
{
  options = {
    programs.emacs.config = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = {
    home.activation.cloneEmacsConfig = mkIf (config.programs.emacs.config != null)
      (lib.home-manager.hm.dag.entryAfter [ "linkGeneration" ] ''
        emacs_dir="${config.home.homeDirectory}/.emacs.d"
        [ -d "$emacs_dir" ] || $DRY_RUN_CMD ${pkgs.git}/bin/git clone ${config.programs.emacs.config} "$emacs_dir"
      '');
  };
}
