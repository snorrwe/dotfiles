{
  flake.modules.nixos.gaming = _: {
    programs.steam = {
      enable = true;
    };
    # Needed For Some Steam Games
    boot.kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
  };
}
