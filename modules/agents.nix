{
  pkgs,
  lib,
  features,
  ...
}:
{
  systemd.tmpfiles.rules = [
    "d /var/agent/ 2775 agent agent-shared"
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
