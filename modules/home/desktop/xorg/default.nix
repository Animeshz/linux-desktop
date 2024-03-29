{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.united.desktop.xorg;
in
{
  options.united.desktop.xorg = {
    enable = mkEnableOption "Enable display management or not";

    hidpi.enable = mkEnableOption "Enable HiDPI settings or not";
    scale = mkOption { type = types.float; default = 1; };
    cursorSize = mkOption { type = types.nullOr types.int; };
    autoRepeat = {
      delay = mkOption { type = types.int; default = 660; };
      rate = mkOption { type = types.int; default = 25; };
    };

    wallpaper = mkOption { type = types.nullOr types.path; };
    installOnHost = mkEnableOption "Manage Xorg and display drivers on host or not";
  };

  config = mkIf cfg.enable {
    puppet.ral.package.xorg = mkIf cfg.installOnHost (
      lib.home-manager.hm.dag.entryAnywhere { ensure = "present"; }
    );

    home.file.".Xresources" = {
      executable = true;
      text = ''
        ! WARNING: This file is generated by home-manager.
        ! Do not edit it!

        Xft.dpi: ${toString (builtins.floor (96 * cfg.scale))}
        Xcursor.size: ${toString cfg.cursorSize}
      '';
    };

    home.file.".xinitrc" = let
      windowManagerCommand = "${pkgs.herbstluftwm}/bin/herbstluftwm --locked";
      barCommand = "${pkgs.eww}/bin/eww open topbar &";
    in
      {
        executable = true;
        text = ''
        # WARNING: This file is generated by home-manager.
        # Do not edit it!

        # Syncs Xresources
        xrdb -merge ~/.Xresources &
        ${pkgs.picom}/bin/picom &
        ${pkgs.ulauncher}/bin/ulauncher --hide-window &
        export GDK_DPI_SCALE=${toString cfg.scale}
        export QT_SCALE_FACTOR=${toString cfg.scale}
        export QT_AUTO_SCREEN_SCALE_FACTOR=0
        ${if cfg.hidpi.enable then "export QT_ENABLE_HIDPI_SCALING=1" else ""}

        # Wallpaper
        ${if cfg.wallpaper != null then "${pkgs.feh}/bin/feh --bg-fill ${cfg.wallpaper}" else "xsetroot -solid '#5A8E3A'"} &

        # Topbar
        ${barCommand}

        # Key hold-repeat frequency
        xset r rate ${toString cfg.autoRepeat.delay} ${toString cfg.autoRepeat.rate}

        exec dbus-launch --exit-with-session ${windowManagerCommand}
      '';
      };

    # This is not working atm
    # environment.etc."X11/xorg.conf.d/00-nix-module-paths.conf".text = ''
    #   Section "Files"
    #     ModulePath "${config.home.profileDirectory}/lib/xorg/modules/"
    #     FontPath "${config.home.profileDirectory}/share/fonts/"
    #     FontPath "${config.home.profileDirectory}/lib/X11/fonts/"
    #   EndSection
    # '';

    environment.etc."X11/xorg.conf.d/20-intel.conf".source = ./files/20-intel.conf;
    environment.etc."X11/xorg.conf.d/40-libinput.conf".source = ./files/40-libinput.conf;
  };
}
