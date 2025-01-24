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
    settings = {
      blur = {
        method = "dual_kawase";
        size = 10;
        strength = 3;
      };
      blur-background = true;
      blur-background-fixed = true;
      corner-radius = 3;
      inactive-opacity-override = true;
      inactive-opacity = 0.92;
      frame-opacity = 0.7;
      shadow = false;
      fading = false;
      log-level = "warn";
    };
  };
}
