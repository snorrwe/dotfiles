{
  # Default feature flags. Host/home entrypoints merge overrides on top.
  nixosDefaults = {
    enableGui = true;
    enableGaming = false;
    enableGamedev = true;
    enableBluetooth = true;
    enableDistrobox = true;
    enableAgents = true;
    enableLocalNetwork = false;
  };

  # Standalone Home Manager, agent box, and similar non-NixOS homes.
  homeDefaults = {
    enableGui = false;
    enableGaming = false;
    enableGamedev = false;
    enableDistrobox = false;
    enableAgents = false;
    enableLocalNetwork = false;
  };
}
