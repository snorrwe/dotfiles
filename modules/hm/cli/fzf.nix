{
  flake.modules.homeManager.cli = { pkgs, ... }: {
    programs.fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      historyWidget.command = "";
      historyWidget.nushell.command = "";
    };
  };
}
