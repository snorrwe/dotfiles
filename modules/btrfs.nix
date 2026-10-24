{ pkgs, ... }:
{
  services = {
    # Periodic Btrfs scrub for data integrity verification
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };

    # Periodic SSD TRIM
    fstrim.enable = true;
  };

  # Reclaim data chunks to leave room for metadata allocation.
  systemd.services.btrfs-home-balance = {
    description = "Reclaim sparsely used Btrfs data chunks on /home";
    unitConfig = {
      RequiresMountsFor = "/home";
      ConditionPathIsMountPoint = "/home";
    };
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;
      IOSchedulingClass = "idle";
    };
    script = ''
      ${pkgs.btrfs-progs}/bin/btrfs balance start -dusage=0 /home
      ${pkgs.btrfs-progs}/bin/btrfs balance start -dusage=5 /home
    '';
  };

  systemd.timers.btrfs-home-balance = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };
}
