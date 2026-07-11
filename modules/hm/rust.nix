{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustup
    cargo-binstall
    cargo-nextest
    cargo-watch
    cargo-clean-recursive
    # topgrade deps to manage cargo-installed packages
    cargo-update
    cargo-cache
  ];
}
