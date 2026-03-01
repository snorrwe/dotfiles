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
            home = "~/.local/share/distrobox/ubuntu24";
            nvidia = true;
          };
        }
        {
          arch = {
            image = "archlinux:latest";
            home = "~/.local/share/distrobox/arch";
            nvidia = true;
          };
        }
      ]
      ++ optionals features.enableAgents [
        {
          agents = {
            image = "registry.fedoraproject.org/fedora-toolbox:latest";
            home = "~/.local/share/distrobox/agents";
            nvidia = true;
          };
        }
      ]
    );
  };
}
