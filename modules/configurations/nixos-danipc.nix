{ inputs, config, ... }:
let
  features = (import ../_lib/features.nix).nixosDefaults // {
    enableGaming = true;
    enableLocalNetwork = true;
  };
in
{
  flake.nixosConfigurations.danipc = import ../_lib/mk-nixos.nix {
    inherit inputs config features;
    host = "danipc";
  };
}
