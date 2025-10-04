{ pkgs, ... }:
{
  services.displayManager.sddm = {
    wayland.enable = true;
    enable = true;
    theme = "catppuccin-mocha-mauve";
    package = pkgs.kdePackages.sddm;
  };
  environment.systemPackages = with pkgs; [
    (catppuccin-sddm.override {
      flavor = "mocha";
      font = "Monaspace Neon";
      fontSize = "13";
      background = ../wallpaper.jpg;
      loginBackground = true;
    })
  ];
}
