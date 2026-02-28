{ config, ... }:
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
    "niri" = mklinkDir "niri";
    "atuin" = mklinkDir "atuin";
    ".zshrc" = {
      source = mkOutOfStoreSymlink "${paths.dotfiles}/.zshrc";
      target = "../.zshrc";
    };
    "xdg-desktop-portal-termfilechooser" = mklinkDir "xdg-desktop-portal-termfilechooser";
    ".visidatarc" = {
      source = mkOutOfStoreSymlink "${paths.dotfiles}/.visidatarc";
      target = "../.visidatarc";
    };
  };
}
