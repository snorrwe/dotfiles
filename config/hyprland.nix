{ pkgs
, lib
, host
, config
, ...
}:

let
in
with lib;
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    plugins = [
      pkgs.hyprlandPlugins.hyprbars
    ];
    systemd.enable = false;
    settings = {
      "$mod" = "SUPER";
      exec-once = [
        # FIX: apps opening slow
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "nm-applet --indicator"
        "waybar"
        "[workspace 1 silent] firefox"
        "[workspace 2 silent] $terminal"
        "[workspace 3 silent] obsidian"
        "[workspace 3 silent] thunderbird"
        "[workspace 4 silent] slack"
        "[workspace 4 silent] telegram-desktop"
      ];
      xwayland = {
        force_zero_scaling = true;
      };
      env = [
        "GDK_SCALE,1.5"
        "XCURSOR_SIZE,32"
      ];
      "$terminal" = "wezterm";
      "$lock" = "hyprlock";
      "$menu" = "wofi --show drun";
      bindm = [
        # Move/resize windows with mod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      binds = {
        allow_workspace_cycles = true;
      };
      bind =
        [
          "$mod, ENTER, exec, $terminal"
          "$mod SHIFT, Q, killactive,"
          "$mod, M, exit,"
          "$mod, V, togglefloating,"
          "$mod, D, exec, $menu"
          "$mod, P, pseudo, # dwindle"
          "$mod, E, togglesplit, # dwindle"
          "$mod, W, togglegroup,"
          "$mod, T, changegroupactive,"
          "$mod, F, fullscreen,"

          # Move focus with mod + arrow keys
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"

          # Example special workspace (scratchpad)
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          # Scroll through existing workspaces with mod + scroll
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          ", Print, exec, grimblast copysave area"
          "$mod SHIFT, L, exec, $lock"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList
            (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );
      windowrulev2 = "suppressevent maximize, class:.*"; # You'll probably like this.


      decoration = {
        rounding = 4;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 0.8;

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = false;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };
      misc = {
        force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
      };

      group = {
        "col.border_active" = "rgba(f5e0dcaa) rgba(b4befeaa) 45deg";
        "col.border_inactive" = "rgba(595959aa)";
        groupbar = {
          enabled = true;
          "col.active" = "rgba(74c7ecaa)";
          "col.inactive" = "rgba(eba09c9c)";
          "col.locked_active" = "rgba(74c7ecaa)";
          "col.locked_inactive" = "rgba(eba09c9c)";
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 0;

        border_size = 2;

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        "col.active_border" = "rgba(f5e0dcaa) rgba(b4befeaa) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };
    };
  };
}


