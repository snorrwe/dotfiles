{
  config,
  pkgs,
  host,
  username,
  options,
  inputs,
  system,
  ...
}:

let
  # mesa 26.2.0 wedges the i915 render engine on this machine (GPU HANG in the
  # iris driver, freezes the whole desktop). Pin the last known good version.
  pkgsMesa = import inputs.nixpkgs-mesa {
    inherit system;
    inherit (config.nixpkgs) config;
  };
in
{
  hardware.graphics = {
    enable = true;
    package = pkgsMesa.mesa;
    package32 = pkgsMesa.pkgsi686Linux.mesa;
    extraPackages = with pkgs; [
      vpl-gpu-rt
      intel-media-driver
      intel-compute-runtime
    ];
  };
}
