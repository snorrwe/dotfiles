{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.wlogout = {
        enable = true;
        layout = [
          {
            label = "lock";
            action = "${pkgs.hyprlock}/bin/hyprlock";
            text = "Lock";
            keybind = "l";
          }
          {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
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
    };
}
