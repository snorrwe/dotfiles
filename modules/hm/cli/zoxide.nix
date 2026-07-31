{ config, ... }:
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };
  home.sessionVariables =
    let
      inherit (config.home) homeDirectory;
    in
    {
      _ZO_EXCLUDE_DIRS = "${homeDirectory}:/mnt/**/*";
    };
}
