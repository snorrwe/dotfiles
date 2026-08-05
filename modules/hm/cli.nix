_: {
  imports = [
    ./cli/zoxide.nix
    ./cli/git.nix
    ./cli/fastfetch.nix
    ./cli/nushell.nix
    ./cli/nvim.nix
    ./cli/yazi.nix
    ./cli/nh.nix
    ./cli/btop.nix
    ./cli/tmux.nix
    ./cli/direnv.nix
    ./cli/devenv.nix
    ./cli/rust.nix
  ];

  programs = {
    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      historyWidget.command = "";
      historyWidget.nushell.command = "";
    };

    eza = {
      enable = true;
      git = true;
    };

    fd = {
      enable = true;
    };

    ripgrep = {
      enable = true;
    };

    jq = {
      enable = true;
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    # colorful, syntax highlighted cat alternative
    bat = {
      enable = true;
      config = {
        theme = "Coldark-Dark";
      };
    };

    lazydocker = {
      enable = true;
    };
  };
}
