{
  inputs,
  config,
  username,
  host ? username,
  system,
  features ? { },
  modules,
}:
let
  inherit (inputs) nixpkgs home-manager;
  pkgs = import nixpkgs { inherit system; };
in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = {
    inherit
      inputs
      username
      host
      features
      ;
  };
  inherit modules;
}
