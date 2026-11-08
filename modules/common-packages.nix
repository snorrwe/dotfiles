{
  flake.modules.nixos.common =
    {
      pkgs,
      features,
      username,
      ...
    }:
    let
      inherit (pkgs.lib.lists) optionals;
    in
    {
      users.users.${username}.packages =
        with pkgs;
        [
          perf
          # quickly fire up VMs
          quickemu
          # nix linter
          statix
        ]
        ++ optionals features.enableGui (
          with pkgs;
          [
            hotspot # perf GUI
            betterlockscreen
            thunar
            okteta
            # niri
            wl-clipboard
            xwayland-satellite
            swaylock
            brightnessctl
            gradia
          ]
        )
        ++ optionals features.enableGamedev [
          pkgs.renderdoc
        ];
    };
}
