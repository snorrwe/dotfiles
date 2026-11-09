{
  inputs,
  config,
  host,
  features,
  extraModules ? [ ],
  username ? "snorrwe",
  system ? "x86_64-linux",
}:
let
  inherit (inputs)
    nixpkgs
    home-manager
    nix-ld
    niri
    flatpaks
    ;
  hm = config.flake.modules.homeManager;
  nixos = config.flake.modules.nixos;
in
nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit
      inputs
      username
      host
      features
      system
      ;
    agentHome = config.flake.homeConfigurations.agent;
  };
  modules = [
    nixos.common
    nixos.${host}
    flatpaks.nixosModules.default
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = {
          inherit
            inputs
            username
            host
            features
            ;
        };
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        users.${username}.imports = [
          hm.common
          hm.cli
          hm.linux
          hm.gui
          hm.sccache
        ];
      };
    }
    { environment.variables.NIX_HOST = host; }
    nix-ld.nixosModules.nix-ld
    { programs.nix-ld.dev.enable = true; }
    niri.nixosModules.niri
  ]
  ++ nixpkgs.lib.lists.optionals features.enableGaming [ nixos.gaming ]
  ++ nixpkgs.lib.lists.optionals features.enableBluetooth [ nixos.bluetooth ]
  ++ extraModules;
}
