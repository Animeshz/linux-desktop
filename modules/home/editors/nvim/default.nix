{ config, lib, pkgs, ... }:

let
  cfg = config.united.editors.nvim;
in
with lib;
{
  options.united.editors.nvim.enable = mkEnableOption "nvim";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      neovim
    ];

    home.sessionVariables.EDITOR = "nvim";
  };
}
