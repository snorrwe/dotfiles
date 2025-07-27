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
    ./rice.nix
    ./dunst.nix
    ./git.nix
    ./xdg.nix
    ./fastfetch.nix
    ./nushell.nix
    ./cli.nix
    ./lockscreen.nix
    ./setup-git-repos.nix
    ./nvim.nix
    ./waybar.nix
    ./wlogout.nix
    ./fuzzel.nix
    ./yazi.nix
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
          "nix"
        ];
        skip_notify = false;
        pre_sudo = true;
      };
    };

  };
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = builtins.readFile ../../dot-wezterm.lua;
    package = inputs.wezterm.packages.${pkgs.system}.default;
  };

}
