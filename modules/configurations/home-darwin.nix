{ inputs, config, ... }:
let
  inherit (inputs) nixpkgs home-manager;
  pkgs = import nixpkgs { system = "aarch64-darwin"; };
  hm = config.flake.modules.homeManager;
in
{
  flake.homeConfigurations."dkiss@danimac" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs;
      username = "dkiss";
      host = "danimac";
    };
    modules = [
      hm.standaloneNixpkgs
      hm.common
      hm.cli
      hm.darwin
    ];
  };
}
