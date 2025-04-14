{
  pkgs,
  username,
  host,
  inputs,
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
}
