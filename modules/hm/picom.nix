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
      inactive-opacity = 0.9;
      frame-opacity = 0.7;
      shadow = false;
      fading = true;
      fade-in-step = 0.03;
      fade-out-step = 0.03;
      fade-delta = 3;

      log-level = "warn";
    };
  };
}
