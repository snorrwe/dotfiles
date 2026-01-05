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
  users.users.agent = {
    enable = features.enableAgents;
    isNormalUser = true;
    extraGroups = [
      "agent-shared"
      "networkmanager"
    ];
    createHome = true;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    password = "";
    packages = with pkgs; [
      distrobox
    ];
  };
  users.extraGroups = {
    agent-shared = { };
  };
}
