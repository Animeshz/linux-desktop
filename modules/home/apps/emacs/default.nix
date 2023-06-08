{ pkgs, lib, config, ... }:

let
  cfg = config.apps.emacs;
in
with lib;
{
  options = {
    apps.emacs.enable = mkEnableOption "Install and configure emacs";
  };

  config = mkIf cfg.enable {
    home.file.".emacs.d" = {
      source = pkgs.sources.emacs.src;
      recursive = true;
    };

    programs.emacs = {
      enable = true;
      extraPackages = epkgs: with epkgs; with pkgs; [
        custom.emacs-pcre
      ];
    };
  };
}