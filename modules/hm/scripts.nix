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
    jq
    (writeScriptBin "niri-fuzzel-select-window" (builtins.readFile ./scripts/niri-fuzzel-select-window))
  ];
}
