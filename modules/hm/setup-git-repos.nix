{
  pkgs,
  lib,
  username,
  ...
}:
{
  home.activation.cloneSnap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    out="/home/${username}/.local/share/zsh-snap"
    if [[ ! -d $out ]]; then
        mkdir -p $(dirname "$out")
        ${pkgs.git}/bin/git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git "$out"
    fi
  '';
}
