{ pkgs, ... }:
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "${pkgs.hyprlock}/bin/hyprlock";
        text = "lock";
        keybind = "l";
      }
      {
        label = "reboot";
        action = "systemctl reboot || loginctl reboot";
        text = "restart_alt";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
    ];
  };
}
