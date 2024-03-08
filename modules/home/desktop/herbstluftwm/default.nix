{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.united.desktop.herbstluftwm;
in
{
  options.united.desktop.herbstluftwm.enable = mkEnableOption "herbstluftwm";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.herbstluftwm ];

    programs.fish.shellInitLast = ''
      if [ -z $DISPLAY ] && [ $(tty) = "/dev/tty1" ];
         pgrep Xorg || startx
      end
    '';
  };
}
