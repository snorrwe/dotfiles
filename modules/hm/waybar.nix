{
  pkgs,
  lib,
  host,
  config,
  features,
  ...
}:

let
  background = "rgba(39, 42, 52, 0.6)";
  color = "#c4c4c4";
  activeBg = "#89b4fa";

  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
in
with lib;
{
  programs.waybar = {
    enable = features.enableGui;
    package = pkgs.waybar;
    systemd = {
      enable = true;
      targets = [
        "graphical-session.target"
      ];
    };
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
          "disk#home"
          "disk#data-0"
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
            "browser" = "🌐";
            "terminal" = "💻";
            "notes" = "󱗖";
            "chat" = "";
            "media" = "🎵";
            # Icons by state
            "default" = "";
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
        "cpu" =
          let
            format = " {usage:2}%";
          in
          {
            interval = 5;
            format-critical = "<span color='#ff0046'><b>${format}</b></span>";
            format-high = "<span color='#e03c52'>${format}</span>";
            format-medium = "<span color='#85c600'>${format}</span>";
            format-low = format;
            tooltip = true;
            states = {
              critical = 90;
              high = 60;
              medium = 15;
              low = 0;
            };
          };
        "disk" = {
          format = " {path} {free}";
          tooltip = true;
        };
        "disk#home" = {
          format = " {path} {free}";
          tooltip = true;
          path = "/home";
        };
        "disk#data-0" = {
          format = " {path} {free}";
          tooltip = true;
          path = "/mnt/data-0";
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
          tooltip = true;
        };
      }
    ];
    style = concatStrings [
      ''
        * {
          font-family: "MonaspiceNe Nerd Font";
          font-size: 14px;
          font-weight: 600;
        }

        window#waybar {
          background-color: ${background};
          color: ${color};
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
          color: ${color};
          border-radius: 8px;
          transition: ${betterTransition};
        }

        #workspaces button:hover {
          background-color: ${activeBg};
          color: #1e1e2e;
          transition: ${betterTransition};
        }

        #workspaces button.active {
          background-color: ${activeBg};
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
          color: ${color};
          background-color: ${background};
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
          color: ${color};
          border-radius: 20px 0 0 20px;
          background-color: ${background};
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
