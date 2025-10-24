{ config, ... }:
let

  paths = {
    # FIXME: the .dotfiles path probably needs configuring
    config = "${config.home.homeDirectory}/.dotfiles/dot-config/";
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
    "starship" = mklinkFile "starship.toml";
    "tmux" = mklinkDir "tmux";
    "niri" = mklinkDir "niri";
    "atuin" = mklinkDir "atuin";
  };
}
