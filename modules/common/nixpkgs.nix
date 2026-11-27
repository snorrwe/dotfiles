{
  flake.modules.nixos.common =
    { inputs, ... }:
    {
      nixpkgs = {
        # Allow unfree packages
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
        ];
        overlays = [
          inputs.niri.overlays.niri
          inputs.rust-overlay.overlays.default
        ];
      };
    };

  # Used by standalone/darwin/agent Home Manager only (not NixOS useGlobalPkgs).
  flake.modules.homeManager.standaloneNixpkgs =
    { inputs, ... }:
    {
      nixpkgs = {
        # Allow unfree packages
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
        ];
        overlays = [
          inputs.niri.overlays.niri
          inputs.rust-overlay.overlays.default
        ];
      };
    };
}
