{ inputs, config, ... }:
let
  inherit (inputs) nixpkgs home-manager;
  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; };
  features = (import ../_lib/features.nix).standaloneHomeDefaults;
  hm = config.flake.modules.homeManager;
  mkHome =
    username:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs username features;
        host = username;
      };
      modules = [
        hm.standaloneNixpkgs
        hm.common
        hm.cli
        hm.linux
        hm.sccache
      ];
    };
in
{
  flake.homeConfigurations.dkiss = mkHome "dkiss";
  flake.homeConfigurations.snorrwe = mkHome "snorrwe";
}
