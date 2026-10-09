{ config, lib, ... }:
let
  cfg = config.dotfiles;

  inherit (config.lib.file) mkOutOfStoreSymlink;
  mklink = name: mkOutOfStoreSymlink "${cfg.dir}/dotfiles/${name}";
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
  options.dotfiles.dir = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/.dotfiles";
    description = "Path to the dotfiles repo checkout.";
  };

  config.xdg.configFile = {
    "starship.toml" = mklinkFile "starship.toml";
    "niri" = mklinkDir "niri";
    "atuin" = mklinkDir "atuin";
    "nvim" = mklinkDir "nvim";
    "xdg-desktop-portal-termfilechooser" = mklinkDir "xdg-desktop-portal-termfilechooser";
    "sccache" = mklinkDir "sccache";
  };
  config.home.file = {
    ".visidatarc" = {
      source = mkOutOfStoreSymlink "${cfg.dir}/dotfiles/.visidatarc";
    };
    ".zshrc" = {
      source = mkOutOfStoreSymlink "${cfg.dir}/dotfiles/.zshrc";
    };
    ".agents" = {
      source = mkOutOfStoreSymlink "${cfg.dir}/dotfiles/agents";
    };
  };
}
