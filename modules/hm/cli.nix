{
  pkgs,
  lib,
  username,
  ...
}:
{
  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };

    eza = {
      enable = true;
      git = true;
    };

    fd = {
      enable = true;
    };

    ripgrep = {
      enable = true;
    };

    jq = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
    };

    # colorful, syntax highlighted cat alternative
    bat = {
      enable = true;
      config = {
        theme = "Coldark-Dark";
      };
    };

    lazydocker = {
      enable = true;
    };
  };
}
