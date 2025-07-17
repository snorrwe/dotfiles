{ config, pkgs, host, username, options, ... }:

{

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ vaapiVdpau intel-media-driver ];
  };
}
