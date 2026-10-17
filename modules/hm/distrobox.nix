{
  config,
  features,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  containers = lib.attrsets.mergeAttrsList [
    {
      debian = {
        additional_packages = "python3 nodejs libnotify-bin";
        image = "docker.io/library/debian:trixie";
        home = "~/.local/share/distrobox/trixie";
        nvidia = true;
      };
    }
    {
      ubuntu24 = {
        additional_packages = "python3 node libnotify";
        image = "docker.io/library/ubuntu:24.04";
        home = "~/.local/share/distrobox/ubuntu24";
        nvidia = true;
      };
    }
    {
      arch = {
        image = "docker.io/library/archlinux:latest";
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

  # Share host configs and nvim plugin data with every container home.
  containerLinks =
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
    containers = lib.mapAttrs (_: c: c // { additional_flags = "--env NIX_REMOTE=daemon"; }) containers;

    enable = features.enableDistrobox;
    enableSystemdUnit = true;
    settings = {
      container_user_custom_home = "$HOME/.local/share/container-home";
      # Use the host store and daemon rather than a separate store inside each box.
      # /etc/static/nix contains the host's nix.conf and flake registry.
      container_additional_volumes = "/nix/store:/nix/store:ro /nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket:ro /etc/static/nix:/etc/nix:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro";
    };
  };

  # The client lives in the shared profile; the daemon and cache remain on the host.
  home.packages = lib.optionals features.enableDistrobox [ pkgs.nixVersions.stable ];

  home.file = lib.mkIf features.enableDistrobox (
    lib.mkMerge (lib.mapAttrsToList (_: c: containerLinks c.home) containers)
  );
}
