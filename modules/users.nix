{
  username,
  pkgs,
  ...
}:
{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "podman"
      "dialout"
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
