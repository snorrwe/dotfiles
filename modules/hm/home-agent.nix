{ lib, pkgs, ... }:
{
  imports = [ ./home.nix ];

  # Agents reuse the normal CLI tools and configs, but have no host SSH keys
  # with which to decrypt the S3 cache credentials.
  disabledModules = [ ./sccache.nix ];

  home.homeDirectory = lib.mkForce "/home/agent";
  # Store-backed configs are self-contained; no host checkout is required.
  dotfiles.dir = toString ../..;

  # There is no desktop session bus inside the box.
  dconf.enable = false;

  home.packages = [ pkgs.nixVersions.stable ];
  programs.bash.enable = true;
}
