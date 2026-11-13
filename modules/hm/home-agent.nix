{
  flake.modules.homeManager.agent =
    { lib, pkgs, ... }:
    {

      # Agents reuse the normal CLI tools and configs, but have no host SSH keys
      # with which to decrypt the S3 cache credentials (kache profile omitted).

      home.homeDirectory = lib.mkForce "/home/agent";
      # Store-backed configs are self-contained; no host checkout is required.
      dotfiles.dir = toString ../..;

      # There is no desktop session bus inside the box.
      dconf.enable = false;

      home.packages = [ pkgs.nixVersions.stable ];
      # Interactive agent-box uses HM zsh so sessionVariables reach the shell.
      home.sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";
      programs = {
        # The box uses the host terminal; do not install an inner tmux or its session manager.
        tmux.enable = lib.mkForce false;
        sesh.enable = lib.mkForce false;
        fzf.tmux.enableShellIntegration = lib.mkForce false;
      };
    };
}
