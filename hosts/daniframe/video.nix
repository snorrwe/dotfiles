{
  config,
  lib,
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

  # btop reads Intel GPU stats through the i915 perf PMU, which needs CAP_PERFMON
  security.wrappers.btop = {
    owner = "root";
    group = "root";
    capabilities = "cap_perfmon=+ep";
    source = lib.getExe config.home-manager.users.${username}.programs.btop.package;
  };
}
