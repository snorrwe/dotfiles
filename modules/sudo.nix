{
  flake.modules.nixos.common = _: {
    security.sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };
}
