{
  pkgs,
  username,
  host,
  inputs,
  ...
}:
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";

  imports = [
    ../../modules/hm/rice.nix
    ../../modules/hm/dunst.nix
    ../../modules/hm/picom.nix
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
        disable = [
          "system"
          "git_repos"
        ];
        pre_sudo = true;
      };
      commands = {
        "System flake" = "cd /home/${username}/.dotfiles && just update ${host}";
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
    difftastic = {
      enable = true;
      background = "dark";
    };
  };
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = builtins.readFile ../../.wezterm.lua;
    package = inputs.wezterm.packages.${pkgs.system}.default;
  };

}
