{ pkgs
, username
, host
, ...
}:
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";

  imports = [
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.topgrade = {
    enable = true;
    package = pkgs.topgrade;
    settings = {
      misc = {
        assume_yes = true;
        cleanup = true;
        disable = [ "system" "git_repos" ];
        pre_sudo = true;
      };
      commands =
        {
          "System flake" = "cd /home/${username}/.dotfiles && ./update.sh ${host}";
        };
    };

  };
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = "Arc-Dark";
    font = "Monaspace Neon 12";
  };
  programs.git = {
    enable = true;
    userName = "Daniel Kiss";
    userEmail = "littlesnorrboy@gmail.com";
    lfs.enable = true;
  };
}
