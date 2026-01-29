{ inputs, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
  ];
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
}
