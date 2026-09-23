{
  config,
  features,
  lib,
  ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  containers = lib.attrsets.mergeAttrsList [
    {
      ubuntu24 = {
        additional_packages = "python3 node libnotify";
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
    {
      fedora = {
        additional_packages = "python3 node libnotify";
        image = "registry.fedoraproject.org/fedora-toolbox:latest";
        home = "~/.local/share/distrobox/fedora";
        nvidia = true;
      };
    }
  ];

  # Share the host's nvim config and plugin data with every container home.
  nvimLinks =
    home:
    let
      rel = lib.removePrefix "~/" home;
      hostData = "${config.home.homeDirectory}/.local/share/nvim";
    in
    {
      "${rel}/.config/nvim".source = mkOutOfStoreSymlink "${config.xdg.configHome}/nvim";
      "${rel}/.local/share/nvim/lazy".source = mkOutOfStoreSymlink "${hostData}/lazy";
      "${rel}/.local/share/nvim/site".source = mkOutOfStoreSymlink "${hostData}/site";
    };
in
{
  programs.distrobox = {
    inherit containers;

    enable = features.enableDistrobox;
    enableSystemdUnit = true;
    settings = {
      container_user_custom_home = "$HOME/.local/share/container-home";
      container_additional_volumes = "/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro";
    };
  };

  home.file = lib.mkIf features.enableDistrobox (
    lib.mkMerge (lib.mapAttrsToList (_: c: nvimLinks c.home) containers)
  );
}
