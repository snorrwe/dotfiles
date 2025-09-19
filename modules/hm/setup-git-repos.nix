{
  pkgs,
  lib,
  username,
  ...
}:
{
  home.activation.cloneTpm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    out="/home/${username}/.config/tmux/plugins/tpm"
    if [[ ! -d $out ]]; then
        mkdir -p $(dirname "$out")
    	rm -f "$out"
        ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$out"
    fi
  '';
  home.activation.cloneSnap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    out="/home/${username}/.local/share/zsh-snap"
    if [[ ! -d $out ]]; then
        mkdir -p $(dirname "$out")
        ${pkgs.git}/bin/git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git "$out"
    fi
  '';
}
