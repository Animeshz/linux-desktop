{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.display;

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
    display.hidpi.enable = mkEnableOption "Enable HiDPI settings or not";
    display.scale = mkOption { type = types.nullOr types.float; };
    display.cursorSize = mkOption { type = types.nullOr types.int; };
    display.autoRepeat = {
      delay = mkOption { type = types.int; default = 660; };
      rate = mkOption { type = types.int; default = 25; };
    };

    display.windowManagers = {
      awesome.enable = mkEnableOption "Setup awesome";
      herbstluftwm.enable = mkEnableOption "Setup hlwm";
      hyprland.enable = mkEnableOption "Setup hyprland";
    };

    display.bars = {
      eww.enable = mkEnableOption "Setup eww";
    };

    display.wallpaper = mkOption { type = types.nullOr types.path; };

    display.fonts = mkOption { type = types.listOf types.package; default = []; };
  };

  config = mkIf (enabledWMs >= 1) {
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
