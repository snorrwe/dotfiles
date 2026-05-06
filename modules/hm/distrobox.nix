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
    enableSystemdUnit = true;
    settings = {
      container_user_custom_home = "$HOME/.local/share/container-home";
      container_additional_volumes = "/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro";
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
