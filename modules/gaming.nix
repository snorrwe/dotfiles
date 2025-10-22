{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
  };
  environment.systemPackages = [
    (pkgs.bottles.override { removeWarningPopup = true; })
  ];
}
