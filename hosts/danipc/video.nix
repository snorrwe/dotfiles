{
  config,
  pkgs,
  ...
}:

{

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      nvidia-vaapi-driver
      intel-media-driver
    ];
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = true;
    nvidiaSettings = true;

    # Modesetting is required.
    modesetting.enable = true;
  };

  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    enable = true;
    videoDrivers = [ "nvidia" ];
    xrandrHeads = [
      {
        output = "HDMI-0";
        primary = true;
      }
      {
        output = "DP-1";
        monitorConfig = ''
          Option "RightOf" "HDMI-0"
        '';
      }
    ];
  };
}
