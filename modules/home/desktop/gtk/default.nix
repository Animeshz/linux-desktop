{ config, lib, pkgs, ... }:

let
  cfg = config.united.desktop.gtk;
in
with lib;
{
  options.united.desktop.gtk.enable = mkEnableOption "inxi";

  config = mkIf cfg.enable {
    # Required to use gtk/dconf options from home-manager
    puppet.ral.package.dconf = { ensure = "installed"; };

    dconf = {
      enable = true;
      settings = with lib.home-manager.hm.gvariant; {
        "org/gtk/settings/file-chooser" = {
          window-position = mkTuple [ 100 100 ];
          window-size = mkTuple [ 500 500 ];
        };
      };
    };

    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.gnome.adwaita-icon-theme;
        name = "Adwaita";
      };
    };
  };
}
