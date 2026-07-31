{ config, ... }:
let
  inherit (config.home) homeDirectory;
in
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };
  home.sessionVariables = {
    _ZO_EXCLUDE_DIRS = "${homeDirectory}:/mnt/**/*";
  };
}
