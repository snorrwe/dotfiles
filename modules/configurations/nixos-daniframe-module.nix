{
  flake.modules.nixos.daniframe = {
    imports = [ ../../hosts/daniframe/config.nix ];
  };
}
