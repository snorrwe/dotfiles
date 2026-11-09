{ inputs, config, ... }:
let
  features = (import ../_lib/features.nix).homeDefaults;
  hm = config.flake.modules.homeManager;
in
{
  flake.homeConfigurations.agent = import ../_lib/mk-home.nix {
    inherit inputs config features;
    username = "snorrwe";
    host = "agent";
    system = "x86_64-linux";
    modules = [
      hm.standaloneNixpkgs
      hm.common
      hm.cli
      hm.linux
      hm.agent
    ];
  };
}
