{ config
, pkgs
, host
, username
, options
, ...
}:

{

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs;[ vaapiVdpau nvidia-vaapi-driver intel-media-driver ];
  };

  hardware.nvidia =
    {
      package = config.boot.kernelPackages.nvidiaPackages.production;
      open = false;
      nvidiaSettings = true;

      # Modesetting is required.
      modesetting.enable = true;
    };

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    enable = true;
    videoDrivers = [ "nvidia" ];
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
