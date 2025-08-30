{ pkgs, lib, ... }:
{
  home.activation.cloneTpm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -d ~/.config/tmux/plugins/tpm/ ]]; then
        mkdir -p ~/.config/tmux/plugins
    	rm -f ~/.config/tmux/plugins/tpm
        ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    fi
  '';
  home.activation.cloneSnap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    out="~/.local/share/zsh-snap"
    if [[ ! -d $out ]]; then
        rm -f "$out"
        mkdir -p $(dirname "$out")
        ${pkgs.git}/bin/git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git "$out"
    fi
  '';
}
