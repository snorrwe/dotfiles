{ pkgs, ... }:
{

  home.packages = with pkgs; [
    lsof
    gawk
    imagemagick
    fzf
    tmux
    (writeScriptBin "portlocate" (builtins.readFile ./scripts/portlocate))
    (writeScriptBin "bincmp" (builtins.readFile ./scripts/bincmp))
    (writeScriptBin "imgcmp" (builtins.readFile ./scripts/imgcmp))
    (writeScriptBin "tmux-select-session" (builtins.readFile ./scripts/tmux-select-session))
    (writeScriptBin "tmux-reset-shells" (builtins.readFile ./scripts/tmux-reset-shells))
    (writeScriptBin "tmux-pull-all" (builtins.readFile ./scripts/tmux-pull-all))
    jq
    (writeScriptBin "niri-fuzzel-select-window" (builtins.readFile ./scripts/niri-fuzzel-select-window))
    (writeScriptBin "wezterm-open-tailscale-ssh" (
      builtins.readFile ./scripts/wezterm-open-tailscale-ssh
    ))
  ];
}
