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
  };
}
