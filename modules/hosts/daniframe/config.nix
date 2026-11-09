{
  flake.modules.nixos.daniframe =
    {
      pkgs,
      username,
      lib,
      ...
    }:
    {
      users.users.${username}.packages = with pkgs; [
        acpi # battery status
        powertop
      ];

      nix.settings.trusted-users = [ "agent" ];

      services.logind.settings.Login = {
        HandleLidSwitchExternalPower = "ignore";
      };

      systemd = {
        # Keeps timing out during boot
        units."dev-tpmrm0.device".enable = false;
        units."dev-tpmrm0.device".wantedBy = lib.mkForce [ ];
      };
    };
}
