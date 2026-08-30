{ config, lib, ... }:
let
  uuidOf = mountPoint: lib.removePrefix "/dev/disk/by-uuid/" config.fileSystems.${mountPoint}.device;
in
{
  services = {

    # Periodic Btrfs scrub for data integrity verification
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [
        "/"
        "/home"
      ];
    };

    # Periodic SSD TRIM
    fstrim.enable = true;

    beesd.filesystems = {
      root = {
        spec = "UUID=${uuidOf "/"}";
        hashTableSizeMB = 2048;
        verbosity = "crit";
        extraOptions = [
          "--loadavg-target"
          "5.0"
        ];
      };
    };
  };

}
