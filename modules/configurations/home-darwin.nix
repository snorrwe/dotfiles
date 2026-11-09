{ inputs, config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.homeConfigurations."dkiss@danimac" = import ../_lib/mk-home.nix {
    inherit inputs config;
    username = "dkiss";
    host = "danimac";
    system = "aarch64-darwin";
    modules = [
      hm.standaloneNixpkgs
      hm.common
      hm.cli
      hm.darwin
    ];
  };
}
