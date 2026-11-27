{
  flake.modules.nixos.common = _: {
    services.displayManager.ly = {
      enable = true;
    };
  };
}
