{
  pkgs,
  ...
}:

{
  security.rtkit.enable = true;
  services = {
    # Enable sound with pipewire.
    pulseaudio.enable = false;
    gnome.gnome-settings-daemon.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber = {
        enable = true;
        package = pkgs.wireplumber;
      };
    };
  };
}
