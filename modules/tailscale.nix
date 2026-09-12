{ pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    # accept the LAN subnet routes the homelab nodes advertise, so pihole
    # (192.168.0.130) and the other 192.168.0.0/24 services resolve and work
    # from outside the home network
    extraSetFlags = [ "--accept-routes" ];
  };
}
