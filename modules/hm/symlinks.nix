{ config, pkgs, lib, ... }:
let

  paths = {
    # FIXME: the .dotfiles path probably needs configuring
    dotfiles = "${config.home.homeDirectory}/.dotfiles/";
    config = "${paths.dotfiles}/dot-config/";
  };

  inherit (config.lib.file) mkOutOfStoreSymlink;
  mklink = name: mkOutOfStoreSymlink "${paths.config}/${name}";
  mklinkDir = name: {
    source = mklink name;
    recursive = true;
  };
  mklinkFile = name: {
    source = mklink name;
    recursive = false;
  };
in
{
  xdg.configFile = {
    "starship.toml" = mklinkFile "starship.toml";
    "atuin" = mklinkDir "atuin";
    "nvim" = mklinkDir "nvim";
    ".zshrc" = {
      source = mkOutOfStoreSymlink "${paths.dotfiles}/.zshrc";
      target = "../.zshrc";
    };
    ".visidatarc" = {
      source = mkOutOfStoreSymlink "${paths.dotfiles}/.visidatarc";
      target = "../.visidatarc";
    };
  } // lib.optionalAttrs pkgs.stdenv.isLinux {
    "niri" = mklinkDir "niri";
    "xdg-desktop-portal-termfilechooser" = mklinkDir "xdg-desktop-portal-termfilechooser";
  };
}
