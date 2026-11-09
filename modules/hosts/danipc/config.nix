{
  flake.modules.nixos.danipc = _: {
    # fix for my wifi dongle disconnecting
    # https://github.com/lwfinger/rtw88/issues/61
    networking.networkmanager = {
      wifi.powersave = false;
      # Was "iwd" for the Intel 6 AX200, but iwd appears to drop LocalSend's
      # multicast discovery (224.0.0.167:53317); daniframe works on the default
      # wpa_supplicant backend. Switch back and watch for AX200 disconnects.
      wifi.backend = "wpa_supplicant";
    };
    # fix for my pcie wifi disconnecting
    boot.extraModprobeConfig = ''
      options iwlwifi 11n_disable=1
      options iwlwifi swcrypto=0
      options iwlwifi power_save=0
      options iwlwifi uapsd_disable=1
      options iwlwifi power_scheme=1
    '';

    services.openssh = {
      enable = true;
      ports = [ 39420 ];
    };

    hardware.nvidia-container-toolkit.enable = true;

    dotfiles.agents.sharedDirectories = [
      {
        hostPath = "/mnt/data-0";
        containerPath = "/workspace/data-0";
      }
    ];
  };
}
