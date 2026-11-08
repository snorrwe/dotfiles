{
  flake.modules.nixos.common = _: {
    services.gnome.gnome-keyring.enable = true;
  };
}
