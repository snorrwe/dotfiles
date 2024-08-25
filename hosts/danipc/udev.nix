{ pkgs
, ...
}:

{
  services.udev = {
    enable = true;
    packages = [ pkgs.usb-modeswitch ];
    extraRules = ''
      ATTR{idVendor}=="0bda", ATTR{idProduct}=="c811", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch '/%k'"
    '';
  };
}
