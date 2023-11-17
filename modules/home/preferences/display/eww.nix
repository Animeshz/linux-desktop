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
      tray-items = pkgs.writeShellScript "tray-items.sh" ''
        ${pkgs.dbus}/bin/dbus-send --dest=org.kde.StatusNotifierWatcher --print-reply=literal \
          /StatusNotifierWatcher org.freedesktop.DBus.Properties.Get \
          string:"org.kde.StatusNotifierWatcher" string:"RegisteredStatusNotifierItems" | tr -dc : | wc -c
      '';
    in ''
      ; =============== Variables ===============

      (defpoll tray-items :interval "2s" `${tray-items}`)

      ; =============== Widgets ===============

      (defwidget separator [?visible]
        (box :style "padding: 0 4px; color: #666666;" :visible {visible ?: true} "|"))

      (defwidget launcher []
        (button :class "blue launcher icon" :onclick "${pkgs.jgmenu}/bin/jgmenu_run" "󱓞"))

      (defwidget battery []
        (label :class "blue"
          :text "''${jq(EWW_BATTERY, "recurse | objects | select(has(\"status\") and .status == \"Charging\") | true") == "true" ? "󰂄"
            : EWW_BATTERY.total_avg < 5 ? "󰂃"
            : EWW_BATTERY.total_avg < 20 ? "󰁻"
            : EWW_BATTERY.total_avg < 40 ? "󰁽"
            : EWW_BATTERY.total_avg < 60 ? "󰁿"
            : EWW_BATTERY.total_avg < 80 ? "󰂁"
            : "󰁹"} ''${round(EWW_BATTERY.total_avg - 0.5, 0)}%"))

      ; =============== Bar Group ===============

      (defwidget barleft []
        (box :class "barleft" :orientation "h" :space-evenly false :halign "start" :spacing 9
          (launcher)
          (separator)
          ))

      (defwidget barright []
        (box :class "barright" :orientation "h" :space-evenly false :halign "end" :spacing 9
          (box :class "icon red" "")
          (box :class "icon red" "")
          (box :class "icon red" "")
          (box :class "icon red" "")
          (box :class "icon red" "󰋊")
          (separator)
          (box :class "icon green" "")
          (box :class "icon magenta" "")
          (box :class "icon yellow" "")
          (box :class "icon red" "󰄨")
          (separator)
          (battery)
          (separator :visible {tray-items != 0})
          (systray :pack-direction "rtl")
          (separator)
          (box :class "yellow" "16 Nov 11:22AM")))

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
          // padding: 0 18px;
        }
      }

      // =============== Styles on classes ===============

      .launcher { /* .barleft */
        padding-left: 18px;
      }
      .barright {
        padding-right: 18px;
      }

      menubar > * {
        padding: 0 4px;
      }
      .icon {
        font-size: 20px;
      }
    '';
  };
}
