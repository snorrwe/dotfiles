{
  description = "snorrwe";

  outputs =
    { self, ... }@args:
    let
      inputs =
        (import ./.tack) {
          overrides = args.tackOverrides or { };
        }
        // args;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
