_:

{
  services.udev = {
    enable = true;
    packages = [ ];
    extraRules = ''
      # openvm board
      KERNEL=="ttyACM*", ATTRS{idVendor}=="37c5", ATTRS{idProduct}=="1060", MODE:="0666", GROUP="dialout"
    '';
  };
}
