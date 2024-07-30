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
    ../../config/waybar.nix
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
      };
      commands =
        {
          "System flake" = "cd /home/${username}/.dotfiles && ./update.sh";
          "Run nix GC" = "nix-collect-garbage -d";
        };
    };

  };
}
