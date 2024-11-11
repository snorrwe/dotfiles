{ pkgs
, username
, host
, inputs
, ...
}:
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";

  imports = [
    ../../config/waybar.nix
    ../../config/hyprland.nix
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

  programs.git = {
    enable = true;
    userName = "Daniel Kiss";
    userEmail = "littlesnorrboy@gmail.com";
    lfs.enable = true;
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        path = "${../..}/wallpaper.jpg";
      };
      input-field = {
        size = [ 200 30 ];
        position = [ 0 "-20" ];
        halign = "center";
        valign = "center";
      };
    };
  };

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "shutdown";
        text = "Shutdown";
        action = "systemctl poweroff";
      }
      {
        label = "lock";
        text = "Lock";
        action = "hyprlock";
      }
    ];
  };
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    # settings managed via stow, because I use imports and apparently
    # home-manager can only handle the 'main' config
  };
}
