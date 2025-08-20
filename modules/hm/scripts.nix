{ pkgs, ... }:
{

  home.packages = with pkgs; [
    lsof
    gawk
    imagemagick
    fzf
    tmux
    (writeShellScriptBin "portlocate" (builtins.readFile ./scripts/portlocate))
    (writeShellScriptBin "bincmp" (builtins.readFile ./scripts/bincmp))
    (writeShellScriptBin "imgcmp" (builtins.readFile ./scripts/imgcmp))
    (writeShellScriptBin "tmux-select-session" (builtins.readFile ./scripts/tmux-select-session))
  ];
}
