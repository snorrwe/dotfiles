{
  pkgs,
  lib,
  ...
}:
{
  systemd.tmpfiles.rules = [
    "d /var/agent/ 2775 agent:agent-shared"
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
