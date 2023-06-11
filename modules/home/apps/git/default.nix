{ pkgs, lib, config, ... }:

let
  cfg = config.apps.git;
in
with lib;
{
  options = {
    apps.git.user = mkOption { type = types.nullOr types.str; };
    apps.git.email = mkOption { type = types.nullOr types.str; };
    apps.git.signingkey = mkOption { type = types.nullOr types.str; };
  };

  config = {
    # TODO: add xbps.rb provider first
    # puppet.ral.package.gnupg = lib.home-manager.hm.dag.entryAnywhere { ensure = "present"; };

    programs.git = {
      enable = true;
      userName = cfg.user;
      userEmail = cfg.email;

      delta.enable = true;
      lfs.enable = true;

      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
        core.symlinks = true;
      };
      ignores = [ "*~" "*.swp" ];

      aliases = {
        exec = "!exec ";  # run command from root of git repository
      };

      signing = {
        key = cfg.signingkey;
        signByDefault = true;
        gpgPath = "/usr/bin/gpg";
      };
    };
  };
}