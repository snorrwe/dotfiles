{
  username,
  pkgs,
  features,
  lib,
  ...
}:
{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ]
    ++ lib.optionals features.enableAgents [
      "agent-shared"
    ];
    createHome = true;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    password = "";
  };
  users.extraGroups = {
    agent-shared = { };
  };
}
