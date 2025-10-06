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
    flatpaks = {
      url = "github:in-a-dil-emma/declarative-flatpak/v3.1.0";
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
      pkgs = import nixpkgs {
        inherit system;
      };
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
                  ./modules/commit-message.nix
                  inputs.flatpaks.nixosModule
                  ./modules/flatpak.nix
                  ./modules/git.nix
                  ./modules/swaybg.nix
                  ./modules/portals.nix
                  ./modules/containers.nix
                  ./modules/nixpkgs.nix
                  ./modules/niri.nix
                  ./modules/users.nix
                  ./modules/sddm.nix
                  ./modules/tailscale.nix
                  home-manager.nixosModules.home-manager
                  ./modules/hm/syncthing.nix
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
      homeConfigurations = builtins.listToAttrs (
        map
          (username: {
            name = username;
            value = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = {
                inherit inputs;
                inherit username;
              };
              modules = [
                ./modules/nixpkgs.nix
                ./modules/hm/home.nix
              ];
            };
          })
          [
            "dkiss"
            "snorrwe"
          ]
      );
    };
}
