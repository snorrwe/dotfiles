{ ... }:
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
        spec = "LABEL=root";
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
