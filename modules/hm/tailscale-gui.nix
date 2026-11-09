{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      systemd.user.services.tailscale-systray = {
        Unit = {
          Description = "Run tailscale systray";
        };
        Service = {
          ExecStart = "${pkgs.tailscale}/bin/tailscale systray";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
}
