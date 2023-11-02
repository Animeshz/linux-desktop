{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.preferences.display;

  enabledWMs = count id (with cfg.windowManagers;
    [ awesome.enable herbstluftwm.enable hyprland.enable ]);

  enabledBars = count id (with cfg.bars;
    [ eww.enable ]);
in
{
  imports = [
    ./xorg.nix
  ];

  options = {
    preferences.display.enable = mkEnableOption "Enable display management or not";

    preferences.display.hidpi.enable = mkEnableOption "Enable HiDPI settings or not";
    preferences.display.scale = mkOption { type = types.nullOr types.float; };
    preferences.display.cursorSize = mkOption { type = types.nullOr types.int; };
    preferences.display.autoRepeat = {
      delay = mkOption { type = types.int; default = 660; };
      rate = mkOption { type = types.int; default = 25; };
    };

    preferences.display.windowManagers = {
      awesome.enable = mkEnableOption "Setup awesome";
      herbstluftwm.enable = mkEnableOption "Setup hlwm";
      hyprland.enable = mkEnableOption "Setup hyprland";
    };

    preferences.display.bars = {
      eww.enable = mkEnableOption "Setup eww";
    };

    preferences.display.wallpaper = mkOption { type = types.nullOr types.path; };

    preferences.display.fonts = mkOption { type = types.listOf types.package; default = []; };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = enabledWMs <= 1;
        message = "Only one of window manager can be enabled at the same time.";
      }
      {
        assertion = enabledBars <= 1;
        message = "Only one of bar can be enabled at the same time.";
      }
    ];

    fonts.fontconfig.enable = true;

    home.packages = mkMerge [
      [ pkgs.feh ]
      cfg.fonts
      (mkIf cfg.windowManagers.awesome.enable [ pkgs.awesome ])
      (mkIf cfg.windowManagers.herbstluftwm.enable [ pkgs.herbstluftwm ])
      (mkIf cfg.windowManagers.hyprland.enable [ pkgs.hyprland ])
      (mkIf cfg.bars.eww.enable [ pkgs.eww ])
    ];

    xdg.configFile."herbstluftwm/autostart" = mkIf cfg.windowManagers.herbstluftwm.enable {
      source = ./herbstluftwm/autostart;
      executable = true;
      # onChange = "${config.xdg.configHome}/herbstluftwm/autostart";
    };

    xdg.configFile."eww" = mkIf cfg.bars.eww.enable {
      source = ./eww;
      recursive = true;
      executable = true;
    };
  };
}
