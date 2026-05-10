{ pkgs, ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = false;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };
}
