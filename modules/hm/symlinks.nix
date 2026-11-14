{
  flake.modules.homeManager.common =
    { config, lib, ... }:
    let
      cfg = config.dotfiles;

      inherit (config.lib.file) mkOutOfStoreSymlink;
      mklink = name: mkOutOfStoreSymlink "${cfg.dir}/dotfiles/${name}";
      mklinkDir = name: {
        source = mklink name;
        recursive = true;
      };
      agentsDir = ../../dotfiles/agents;
      skillEntries = builtins.readDir (agentsDir + "/skills");
      skillDirs = builtins.filter (name: skillEntries.${name} == "directory") (
        builtins.attrNames skillEntries
      );

      mapSkill = dst: name: {
        name = "${dst}/${name}";
        value = {
          source = mkOutOfStoreSymlink "${cfg.dir}/dotfiles/agents/skills/${name}";
        };
      };
    in
    {
      options.dotfiles.dir = lib.mkOption {
        type = lib.types.str;
        default = "${config.home.homeDirectory}/.dotfiles";
        description = "Path to the dotfiles repo checkout.";
      };

      config.xdg.configFile = {
        "niri" = mklinkDir "niri";
        "atuin" = mklinkDir "atuin";
        "nvim" = mklinkDir "nvim";
        "xdg-desktop-portal-termfilechooser" = mklinkDir "xdg-desktop-portal-termfilechooser";
      };
      config.home.file = {
        ".visidatarc".source = mkOutOfStoreSymlink "${cfg.dir}/dotfiles/.visidatarc";
      }
      // builtins.listToAttrs (map (mapSkill ".agents/skills") skillDirs);
    };
}
