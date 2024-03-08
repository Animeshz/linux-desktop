{ config, lib, pkgs, ... }:

let
  cfg = config.united.cli.fish;
  mkPlugin = name: with pkgs.nvfetcher-sources."${name}"; { name = pname; inherit src; };
in
with lib;
{
  options.united.cli.fish.enable = mkEnableOption "fish";

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      functions = import ./functions.nix;
      plugins = map (n: mkPlugin n) ["nix-fish" "nvm-fish"];

      shellInit = ''
        set fish_greeting
      '';
    };
  };
}
