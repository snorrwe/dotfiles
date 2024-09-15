{ pkgs
, ...
}:

{
  hardware.usb-modeswitch.enable = true;
  services.udev = {
    enable = true;
    packages = [ pkgs.usb-modeswitch ];
    extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="c811", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch '/%k'"
    '';
  };
}
