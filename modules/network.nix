{
  flake.modules.nixos.common =
    { host, pkgs, ... }:
    {
      networking.hostName = host;
      networking.networkmanager = {
        enable = true;
        plugins = with pkgs; [
          networkmanager-openvpn
        ];
      };
    };
}
