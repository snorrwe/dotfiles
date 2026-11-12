{
  flake.modules.homeManager.agent =
    { lib, pkgs, ... }:
    {

      # Agents reuse the normal CLI tools and configs, but have no host SSH keys
      # with which to decrypt the S3 cache credentials (sccache profile omitted).

      home.homeDirectory = lib.mkForce "/home/agent";
      # Store-backed configs are self-contained; no host checkout is required.
      dotfiles.dir = toString ../..;

      # There is no desktop session bus inside the box.
      dconf.enable = false;

      home.packages = [ pkgs.nixVersions.stable ];
      # The box uses the host terminal; do not install an inner tmux or its session manager.
      programs.tmux.enable = lib.mkForce false;
      programs.sesh.enable = lib.mkForce false;
      programs.fzf.tmux.enableShellIntegration = lib.mkForce false;
      programs.bash.enable = true;
    };
}
