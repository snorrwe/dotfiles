{ inputs, ... }:
{
  nixpkgs = {
    # Allow unfree packages
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
    ];
    overlays = [ inputs.niri.overlays.niri ];
  };
}
