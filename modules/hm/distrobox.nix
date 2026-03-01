{
  pkgs,
  features,
  lib,
  ...
}:
let
  inherit (pkgs.lib.lists) optionals;
in
{
  programs.distrobox = {
    enable = features.enableDistrobox;
    settings = {
      container_user_custom_home = "$HOME/.local/share/container-home";
    };
    containers = lib.attrsets.mergeAttrsList (
      [
        {
          ubuntu24 = {
            image = "ubuntu:24.04";
            nvidia = true;
          };
        }
        {
          arch = {
            image = "archlinux:latest";
            nvidia = true;
          };
        }
      ]
      ++ optionals features.enableAgents [
        {
          agents = {
            image = "ubuntu:24.04";
            home = "~/.local/share/agents-home/";
            nvidia = true;
          };
        }
      ]
    );
  };
}
