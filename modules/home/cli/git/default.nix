{ config, lib, pkgs, ... }:

let
  cfg = config.united.cli.git;
in
with lib;
{
  options.united.cli.git = {
    enable = mkEnableOption "git";
    user = mkOption { type = types.nullOr types.str; };
    email = mkOption { type = types.nullOr types.str; };
    signingkey = mkOption { type = types.nullOr types.str; };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gnupg
      neovim
    ];

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
        rerere.enabled = true;
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
