{
  config,
  pkgs,
  host,
  username,
  options,
  ...
}:

{

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      intel-media-driver
    ];
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        rofi
        polybar
        feh
      ];
    };
  };
}
