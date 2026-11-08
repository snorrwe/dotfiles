{
  flake.modules.nixos.common = _: {
    boot.loader.timeout = 2;
  };
}
