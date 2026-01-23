{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez5-experimental;
    settings.Policy.AutoEnable = "true";
    settings.General = {
      Experimental = true;
      Enable = "Source,Sink,Media,Socket";
    };
  };
  services.blueman.enable = true;
}
