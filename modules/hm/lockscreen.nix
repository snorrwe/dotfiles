{ pkgs, lib, features, ... }:
let
  timeout = 300;
  font = "MonaspiceNe Nerd Font";
in {
  services.hypridle = {
    enable = features.enableGui;
    settings = {
      listener = [
        {
          timeout = timeout - 30;
          on-timeout = ''
            ${pkgs.libnotify}/bin/notify-send -u critical -t 30000 "Locking screen in 30 seconds"'';
        }
        {
          timeout = timeout;
          on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
        }
      ];
    };
  };
  programs.hyprlock = let textColor = "rgb(cdd6f4)";
  in {
    enable = features.enableGui;
    settings = {
      background = [{
        path = "${../../wallpaper.jpg}";
        blur_passes = 1;
      }];
      label = [
        {
          text = "cmd[update:1000] echo $TIME";
          position = "-16, -16";
          font_family = font;
          font_size = 64;
          halign = "right";
          valign = "top";
          shadow_passes = 2;
          color = textColor;
        }
        {
          text = ''cmd[update:43200000] date +"%A, %d %B %Y"'';
          color = textColor;
          position = "-16, -150";
          font_family = font;
          font_size = 25;
          halign = "right";
          valign = "top";
          shadow_passes = 2;
        }
        {
          color = textColor;
          text = "Password for $USER";
          font_family = font;
          shadow_passes = 2;
        }
      ];
      input-field = [{
        font_family = font;
        size = "200, 50";
        position = "0, -80";
        monitor = "";
        dots_center = true;
        fade_on_empty = true;
        font_color = textColor;
        inner_color = " rgb(313244)";
        outer_color = "rgb(cba6f7)";
        outline_thickness = 4;
        dots_size = 0.2;
        dots_spacing = 0.2;
        placeholder_text = "Password...";
        shadow_passes = 2;
        capslock_color = "rgb(f9e2af)";
        halign = "center";
        valign = "center";
      }];
    };
  };
}
