{
  flake.modules.homeManager.agent =
    { lib, pkgs, ... }:
    {

      # Agents reuse the normal CLI tools and configs, but have no host keys
      # with which to decrypt S3 cache credentials — use local-only Kache.
      kache.enableRemote = false;
      home = {
        homeDirectory = lib.mkForce "/home/agent";
        packages = [ pkgs.nixVersions.stable ];
        # Interactive agent-box uses HM zsh so sessionVariables reach the shell.
        sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";
      };

      # Store-backed configs are self-contained; no host checkout is required.
      dotfiles.dir = toString ../..;

      # There is no desktop session bus inside the box.
      dconf.enable = false;
      programs = {
        # The box uses the host terminal; do not install an inner tmux or its session manager.
        tmux.enable = lib.mkForce false;
        sesh.enable = lib.mkForce false;
        fzf.tmux.enableShellIntegration = lib.mkForce false;
      };
    };
}
