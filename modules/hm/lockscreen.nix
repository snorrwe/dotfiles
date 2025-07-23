{
  pkgs,
  lib,
  ...
}:
let
  timeout = 300;
  font = "Monaspace Neon";
in
{
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = timeout;
        command = "${pkgs.hyprlock}/bin/hyprlock";
      }
      {
        timeout = timeout + 60;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
      {
        timeout = timeout + 90;
        command = "systemctl suspend";
      }
    ];
  };
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          path = "${../../wallpaper.jpg}";
          blur_passes = 1;
        }
      ];
      label = [
        {
          text = "cmd[update:1000] echo $TIME";
          position = "-16, -16";
          font_family = font;
          font_size = 64;
          halign = "right";
          valign = "top";
          shadow_passes = 2;
        }
        {
          text = "Password for $USER";
          font_family = font;
          shadow_passes = 2;
        }
      ];
      input-field = [
        {
          font_family = font;
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = true;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "Password...";
          shadow_passes = 2;
        }
      ];
    };
  };
}
