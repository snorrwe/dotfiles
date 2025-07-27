{
  description = "snorrwe";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-ld,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      username = "snorrwe";
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map
          (
            { host }:
            {
              name = host;
              value = nixpkgs.lib.nixosSystem {
                specialArgs = {
                  inherit system;
                  inherit inputs;
                  inherit username;
                  inherit host;
                };
                modules = [
                  ./hosts/${host}/config.nix
                  ./modules/network-stats.nix
                  home-manager.nixosModules.home-manager
                  {
                    home-manager.extraSpecialArgs = {
                      inherit inputs;
                      inherit username;
                      inherit host;
                    };
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.backupFileExtension = "backup";
                    home-manager.users.${username} = import ./modules/hm/home.nix;
                  }
                  {
                    environment.variables.NIX_HOST = host;
                  }

                  # enable nix-ld
                  nix-ld.nixosModules.nix-ld
                  { programs.nix-ld.dev.enable = true; }
                ];
              };
            }
          )
          [
            { host = "danipc"; }
            { host = "danilife"; }
          ]
      );
    };
}
