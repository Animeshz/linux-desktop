{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.preferences.display.windowManagers;

  withModKey = lib.mapAttrs' (key: lib.nameValuePair "${cfg.modKey}-${key}");
  generateDirectionalKeys = { action, prefix ? "" }:
    let
      keyset1 = [ "h" "j" "k" "l" ];
      keyset2 = [ "Left" "Down" "Up" "Right" ];
      directions = [ "left" "down" "up" "right" ];
      prefixOver = key: if prefix == "" then key else "${prefix}-${key}";
      toAttr = key: direction: { name = prefixOver key; value = "${action} ${direction}"; };
    in
      lib.listToAttrs (lib.zipListsWith toAttr keyset1 directions)
      // lib.listToAttrs (lib.zipListsWith toAttr keyset2 directions);

  # HLWM's klib
  klib = {
    inherit withModKey;
    launch = app: "spawn ${app}";
  };
in
{
  options = {
    preferences.display.windowManagers.herbstluftwm.enable = mkEnableOption "Setup hlwm";
  };

  config = mkIf cfg.herbstluftwm.enable {
    home.packages = [ pkgs.herbstluftwm ];

    xsession.windowManager.herbstluftwm = {
      enable = true;

      # applied using "hc set <attr> <value>"
      settings = {
        tree_style = "╾│ ├└╼─┐";
        show_frame_decorations = "none";
        focus_follows_mouse = false;
        focus_stealing_prevention = true;   # use Mod+i instead
        update_dragged_clients = false;     # resize only after dragging ends

        frame_border_width = 0;
        frame_gap = 0;
        frame_padding = 0;
        snap_gap = 5;
        window_gap = 5;

        smart_window_surroundings = true;
        smart_frame_surroundings = false;

        window_border_width = 2;
        window_border_active_color = "#00b7eb";
        window_border_normal_color = "#eeeeee";
        window_border_urgent_color = "#7811A1";
      };

      # applied using "hc keybind <key> <command>"
      keybinds = lib.mkMerge [
        (withModKey ({
          Shift-q = "quit";
          Shift-r = "reload";
          Shift-w = "close";

          r = "remove";
          s = "floating toggle";
          f = "fullscreen toggle";
          i = "jumpto urgent";  # clicking-links & jupyter-lab makes browser window urgent, jump there

          u = "split bottom";
          o = "split right";

          comma = "use_index -1 --skip-visible";
          period = "use_index +1 --skip-visible";
          Shift-Tab = "cycle_all -1";
          Tab = "cycle_all +1";

          # TODO: make the scratchpad tag hidden (from Mod-,. and Mod-num and eww bar)
          p = klib.launch "${pkgs.herbstluftwm.doc}/share/doc/herbstluftwm/examples/q3terminal.sh"; # scratchpad
          space = "or , and . compare tags.focus.curframe_wcount = 2 . " +
                  "cycle_layout +1 vertical horizontal max vertical grid , cycle_layout +1";
        }
        // generateDirectionalKeys { action = "focus"; }
        // generateDirectionalKeys { action = "shift"; prefix = "Shift"; }
        // generateDirectionalKeys { action = "resize"; prefix = "Ctrl"; }))
        (cfg.extraKeybinds klib)
      ];

      # applied using "hc mousebind <key> <command>"
      mousebinds = lib.mkMerge [
        (withModKey {
          Button1 = "move";
          Button2 = "zoom";
          Button3 = "resize";
        })
        (cfg.extraMousebinds klib)
      ];

      tags = [ "1" "2" "3" "4" "5" ];

      # applied using "hc rule <conditions> <consequences>"
      rules = [
        "focus=on floatplacement=smart"  # for all clients
        "fixedsize floating=on"          # non-resizables
        "windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK|DESKTOP)' manage=off" # panels, docks
        "windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)' floating=on"    # rofi
        "class='Brave-browser' tag=2 switchtag=on floatplacement=smart"
      ];

      extraConfig = ''
        for i in {0..9}; do
            key=$(((i+1)%10))
            herbstclient keybind "${cfg.modKey}-$key" use_index "$i"
            herbstclient keybind "${cfg.modKey}-Shift-$key" move_index "$i"
        done

        herbstclient detect_monitors

        # if herbstclient silent new_attr bool is_first_run && [[ $(cat /proc/scsi/scsi) =~ VMware ]]; then
        #     { sleep 5 && logger 'Running vmware cmd' && vmware-toolbox-cmd timesync enable && vmware-user &> /dev/null } &
        # fi
      '';
    };
  };
}
