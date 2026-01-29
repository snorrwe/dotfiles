{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri.override {
      withDbus = false;
    };
  };
}
