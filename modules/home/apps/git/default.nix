{ pkgs, lib, config, ... }:

let
  cfg = config.apps.git;
in
with lib;
{
  options = {
    apps.git.enable = mkEnableOption "Enable management of git";
    apps.git.user = mkOption { type = types.nullOr types.str; };
    apps.git.email = mkOption { type = types.nullOr types.str; };
    apps.git.signingkey = mkOption { type = types.nullOr types.str; };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.gnupg ];
    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "curses";
    };

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

      signing = mkIf (cfg.signingkey != null) {
        key = cfg.signingkey;
        signByDefault = true;
      };
    };
  };
}
