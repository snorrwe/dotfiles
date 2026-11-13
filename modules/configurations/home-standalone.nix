{ inputs, config, ... }:
let
  features = (import ../_lib/features.nix).homeDefaults;
  hm = config.flake.modules.homeManager;
  mkHome =
    username:
    import ../_lib/mk-home.nix {
      inherit
        inputs
        config
        username
        features
        ;
      system = "x86_64-linux";
      modules = [
        hm.standaloneNixpkgs
        hm.common
        hm.cli
        hm.linux
        hm.kache
      ];
    };
in
{
  flake.homeConfigurations.dkiss = mkHome "dkiss";
  flake.homeConfigurations.snorrwe = mkHome "snorrwe";
}
