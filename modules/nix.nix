{
  flake.modules.nixos.common =
    { pkgs, username, ... }:
    {
      nix = {
        package = pkgs.nixVersions.stable;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          auto-optimise-store = true;
          trusted-users = [ username ];
        };
      };
    };
}
