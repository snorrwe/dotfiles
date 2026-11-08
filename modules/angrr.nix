{
  flake.modules.nixos.common = _: {
    services.angrr = {
      enable = true;
    };
  };
}
