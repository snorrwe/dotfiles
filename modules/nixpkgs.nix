{ ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    # TODO: remove when geeqie upgrades to libsoup3
    # PR: https://github.com/NixOS/nixpkgs/pull/429656 already merged
    "libsoup-2.74.3"
  ];
}
