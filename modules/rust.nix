# install binaries via cargo
{ pkgs, ... }:

let
  desiredPackages = [
    "cargo-nextest"
    "cargo-watch"
    "cargo-clean-recursive"
    "sqlx-cli"
  ];
in
{
  system.activationScripts.cargo-binstall = {
    text = ''
      ${pkgs.cargo-binstall}/bin/cargo-binstall -y ${toString desiredPackages}
    '';
  };
}
