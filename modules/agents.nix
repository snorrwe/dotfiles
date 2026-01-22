{
  pkgs,
  lib,
  username,
  ...
}:
{
  systemd.tmpfiles.rules = [
    "d /var/agent/ 0755 ${username} agent-shared"
  ];

  users.users.agent.packages = (
    import ./common-packages.nix {
      inherit pkgs lib;
      features = {
        enableGui = false;
        enableSyncthing = false;
        enableGaming = false;
        enableAgents = true;
        enableGamedev = false;
      };
    }
  );
}
