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
      libva-vdpau-driver
      intel-media-driver
    ];
  };
}
