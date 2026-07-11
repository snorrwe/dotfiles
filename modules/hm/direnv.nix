_: {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      disable_stdin = true;
      strict_env = true;
      hide_env_diff = true;
    };
  };
}
