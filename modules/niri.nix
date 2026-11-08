{
  flake.modules.nixos.common =
    { pkgs, ... }:
    {
      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };
    };
}
