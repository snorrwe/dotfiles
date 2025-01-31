{
  pkgs,
  username,
  host,
  inputs,
  ...
}:
{
  services.picom = {
    enable = true;
    backend = "glx";
    inactiveOpacity = 0.9;
    opacityRules = [
      "100:class_g = 'firefox'"
      "100:class_g = 'obsidian'"
      "100:class_g = 'Rofi'"
    ];
    settings = {
      blur = {
        method = "dual_kawase";
        size = 10;
        strength = 3;
      };
      blur-background = true;
      blur-background-fixed = true;
      corner-radius = 3;
      frame-opacity = 0.7;
      shadow = false;
      fading = false;
      log-level = "warn";
      inactive-dim = 0.05;
    };
  };
}
