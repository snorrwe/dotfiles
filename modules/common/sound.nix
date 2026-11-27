{
  flake.modules.nixos.common =
    { pkgs, ... }:
    {
      security.rtkit.enable = true;
      # Provides `pw-jack` so JACK apps can use PipeWire without global LD_LIBRARY_PATH.
      environment.systemPackages = [ pkgs.pipewire.jack ];
      services = {
        pulseaudio.enable = false;
        gnome.gnome-settings-daemon.enable = true;
        pipewire = {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
          pulse.enable = true;
          wireplumber = {
            enable = true;
            package = pkgs.wireplumber;
          };
        };
      };
    };
}
