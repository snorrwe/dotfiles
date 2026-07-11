{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default))

    cargo-binstall
    cargo-nextest
    cargo-watch
    cargo-clean-recursive
    # topgrade deps to manage cargo-installed packages
    cargo-update
    cargo-cache
  ];
}
