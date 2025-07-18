{
  pkgs,
  lib,
  host,
  config,
  ...
}:

let
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
in
with lib;
{
  # Configure & Theme Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";
        position = "top";
        modules-left = [ "niri/workspaces" ];
        modules-center = [
          "niri/window"
          "custom/notification"
        ];
        modules-right = [
          "pulseaudio"
          "cpu"
          "memory"
          "disk"
          "battery"
          "clock"
          "tray"
          "custom/exit"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        "niri/workspaces" = {
          "format" = "{value} {icon}";
          "format-icons" = {
            # Named workspaces
            # (you need to configure them in niri)
            "browser" = "";
            "discord" = "";
            "chat" = "<b></b>";
            # Icons by state
            "active" = "";
            "default" = "";
          };
        };
        "clock" = {
          format = " {:%a %Y-%m-%d %H:%M}";
          tooltip = true;
          tooltip-format = ''
            <big>{:%A, %d.%B %Y }</big>
            <tt><small>{calendar}</small></tt>'';
          actions = {
            "on-click-right" = "mode";
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
          };
        };
        "hyprland/window" = {
          max-length = 22;
          separate-outputs = false;
          rewrite = {
            "" = " 🙈 No Windows? ";
          };
        };
        "memory" = {
          interval = 5;
          format = " {}%";
          tooltip = true;
        };
        "cpu" = {
          interval = 5;
          format = " {usage:2}%";
          tooltip = true;
        };
        "disk" = {
          format = " {free}";
          tooltip = true;
        };
        "network" = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-ethernet = " {bandwidthDownOctets}";
          format-wifi = "{icon} {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = true;
        };
        "tray" = {
          spacing = 12;
        };
        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = "🔇{icon} {format_source}";
          format-muted = "🔇 {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "sleep 0.1 && pavucontrol";
        };
        "custom/exit" = {
          tooltip = false;
          format = "";
          on-click = "sleep 0.1 && ${pkgs.wlogout}/bin/wlogout";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon} {}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && task-waybar";
          escape = true;
        };
        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          on-click = "";
          tooltip = false;
        };
      }
    ];
    style = concatStrings [
      ''
        * {
          font-family: "Monaspace Neon";
          font-size: 14px;
          font-weight: 600;
        }

        window#waybar {
          background-color: rgba(39, 42, 52, 0.5);
          color: #c4c4c4;
          transition-property: background-color;
          transition-duration: 0.5s;
        }

        button {
          border: none;
          border-radius: 0;
        }

        button:hover {
          background: inherit;
        }

        #workspaces button {
          padding: 0 10px;
          background-color: transparent;
          color: #c4c4c4;
          border-radius: 8px;
          transition: ${betterTransition};
        }

        #workspaces button:hover {
          background-color: #89b4fa;
          color: #1e1e2e;
          transition: ${betterTransition};
        }

        #workspaces button.active {
          background-color: #89b4fa;
          color: #1e1e2e;
          font-weight: bold;
          min-width: 20px;
          transition: ${betterTransition};
        }

        #workspaces button.urgent {
          background-color: #f38ba8;
          color: #1e1e2e;
          transition: ${betterTransition};
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #backlight,
        #network,
        #pulseaudio,
        #custom-media,
        #tray,
        #bluetooth {
          padding: 5px 15px;
          color: #c4c4c4;
          background-color: rgba(39, 42, 52, 0.6);
        }

        #window,
        #workspaces {
          margin: 0 4px;
        }

        .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
        }

        .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
        }

        #custom-exit,
        #disk {
          margin: 0 5px;
          padding: 5px 15px;
          color: #c4c4c4;
          border-radius: 20px 0 0 20px;
          background-color: rgba(39, 42, 52, 0.6);
        }

        #battery.charging {
          color: #00ff1c;
        }

        #battery.warning {
          color: orange;
        }

        #battery.critical {
          color: #ff0046;
        }


        #clock {
          border-radius: 20px;
          margin: 0 5px;
        }

        #battery {
          border-radius: 0 20px 20px 0;
        }

        #pulseaudio {
          border-radius: 0 20px 20px 0;
        }

        #pulseaudio.muted {
          color: orange;
        }

        #network.disconnected {
          color: #ff0046;
        }

        #tray {
          border-radius: 20px;
          margin: 0 5px;
        }

        #cpu {
          border-radius: 20px 0 0 20px;
        }

        #memory {
          border-radius: 0 20px 20px 0;
        }

        #bluetooth {
          border-radius: 20px;
          margin: 0 5px;
        }

      ''
    ];
  };
}
