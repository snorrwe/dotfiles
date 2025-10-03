{ username, pkgs, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    createHome = true;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };
}
