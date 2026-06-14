_:
let
  firewallPort = 53317;
in
{
  networking.firewall.allowedTCPPorts = [ firewallPort ];
  networking.firewall.allowedUDPPorts = [ firewallPort ];
}
