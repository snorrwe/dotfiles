{ inputs, config, ... }:
let
  features = (import ../_lib/features.nix).nixosDefaults;
in
{
  flake.nixosConfigurations.daniframe = import ../_lib/mk-nixos.nix {
    inherit inputs config features;
    host = "daniframe";
    extraModules = [
      inputs.nixos-hardware.nixosModules.framework-12-13th-gen-intel
    ];
  };
}
