{ pkgs, username, host, inputs, ... }: {
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";

  imports = [
    ../../modules/hm/rice.nix
    ../../modules/hm/dunst.nix
    ../../modules/hm/git.nix
    ../../modules/hm/xdg.nix
    ../../modules/hm/fastfetch.nix
    ../../modules/hm/nushell.nix
    ../../modules/hm/cli.nix
    ../../modules/hm/nvim.nix
    ../../modules/hm/lockscreen.nix
    ../../modules/hm/setup-git-repos.nix
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
        disable = [ "system" "git_repos" "nix" ];
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
