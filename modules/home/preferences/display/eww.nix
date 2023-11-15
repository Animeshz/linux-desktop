{ pkgs, lib, config, ... }:

with lib;
with lib.internal;
let
  cfg = config.preferences.display.bars;
in {
  options = {
    preferences.display.bars.eww.enable = mkEnableOption "Setup eww";

  };

  config = mkIf cfg.eww.enable {
    home.packages = [ pkgs.eww ];

    xdg.configFile."eww/eww.yuck".text = let
      a = 7; # scripts
    in ''
      ; =============== Variables ===============


      ; =============== Widgets ===============

      (defwidget separator []
        (box :style "padding: 0 4px 0 4px; color: #666666;" "|"))

      (defwidget launcher []
        (button :class "blue" :style "background: rgba(#ffffff,0);" :onclick "" "󱓞"))

      ; =============== Bar Group ===============

      (defwidget barleft []
        (box :orientation "h" :space-evenly false :halign "start" :spacing 9
          (launcher)
          (separator)))

        (defwidget barright []
          (box :orientation "h" :space-evenly false :halign "end" :spacing 9
            "End of the bar"))

      ; =============== Top-Level Window Definitions ===============

      (defwindow topbar
        :monitor 0 :stacking "fg" :wm-ignore false :windowtype "dock"
        :reserve (struts :side "top" :distance "${toString (cfg.height+2)}px")
        :geometry (geometry :x "0" :y "0" :width "100%" :height "${toString cfg.height}px" :anchor "top center")
        (box (barleft) (barright)))
    '';

    xdg.configFile."eww/eww.scss".text = ''
      // =============== Colors ===============

      $color0:               #1E1E2E;
      $color1:               #f38ba8;
      $color2:               #7fe173;
      $color3:               #f9e2af;
      $color4:               #89b4fa;
      $color5:               #cba6f7;
      $color6:               #bed6ff;
      $color7:               #cdd6f4;
      $widget_bg:            transparent;

      .black {
        color: $color0;
      }
      .red {
        color: $color1;
      }
      .green {
        color: $color2;
      }
      .yellow {
        color: $color3;
      }
      .blue {
        color: $color4;
      }
      .magenta {
        color: $color5;
      }
      .cyan {
        color: $color6;
      }
      .white {
        color: $color7;
      }

      // =============== Global Styles ===============

      * {
        all: unset;
        min-height: ${toString cfg.height}px;
      }

      .topbar:nth-child(1) {
        font-family: "CaskaydiaCove Nerd Font", "Phosphor";
        font-size: 18px;

        background-color: #1E1E2E;

        // https://github.com/elkowar/eww/issues/497#issuecomment-1197040374
        & > * {
          padding: 0 18px;
        }
      }

      // =============== Styles on classes ===============

    '';
  };
}
