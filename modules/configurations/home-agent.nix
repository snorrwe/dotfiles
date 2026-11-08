{ inputs, config, ... }:
let
  inherit (inputs) nixpkgs home-manager;
  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; };
  username = "snorrwe";
  features = (import ../_lib/features.nix).agentDefaults;
  hm = config.flake.modules.homeManager;
in
{
  flake.homeConfigurations.agent = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs username features;
      host = "agent";
    };
    modules = [
      hm.standaloneNixpkgs
      hm.common
      hm.cli
      hm.linux
      hm.agent
    ];
  };
}
