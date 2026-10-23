{
  pkgs,
  config,
  host,
  ...
}:
let
  inherit (pkgs.lib.lists) optionals;
in
{
  programs.topgrade = {
    enable = true;
    package = pkgs.topgrade;
    settings = {
      commands = {
        "Agent Box update" = "agent-box --no-cwd -- topgrade";
      };
      misc = {
        assume_yes = true;
        cleanup = true;
        disable = [
          "system"
          "nix"
          "home_manager"
          "rustup"
        ]
        ++ optionals (host != "agent") [
          "pi"
          "claude_code"
          "claude_code_plugins"
          "codex"
          "cursor"
          "cursor_agent"
        ];
        skip_notify = false;
        pre_sudo = true;
      };
      git = {
        repos = [
          "${config.home.homeDirectory}/.local/share/zsh-snap"
        ];
        arguments = "--rebase --autostash";
      };
    };

  };
}
