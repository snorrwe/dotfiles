{
  pkgs,
  lib,
  username,
  ...
}:
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.eza = {
    enable = true;
    git = true;
  };

  programs.fd = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.jq = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  # colorful, syntax highlighted cat alternative
  programs.bat = {
    enable = true;
    config = {
      theme = "Coldark-Dark";
    };
  };

  programs.lazydocker = {
    enable = true;
  };
}
