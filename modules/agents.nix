{
  pkgs,
  lib,
  features,
  username,
  ...
}:
{
  systemd.tmpfiles.rules = [
    "d /var/agent/ 2775 agent agent-shared"
    "d /var/agent/distrobox-home/ 2775 ${username} agent-shared"
  ];

  users.users.agent = {
    enable = features.enableAgents;
    packages = (
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
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "docker"
      "agent-shared"
    ];
    createHome = true;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    password = "";
  };
}
