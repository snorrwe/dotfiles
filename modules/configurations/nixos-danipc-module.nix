{
  flake.modules.nixos.danipc = {
    imports = [ ../../hosts/danipc/config.nix ];
  };
}
