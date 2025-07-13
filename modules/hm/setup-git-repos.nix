{ pkgs, lib, ... }:
{
  home.activation.cloneTpm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -d ~/.config/tmux/plugins/tpm/ ]]; then
        mkdir -p ~/.config/tmux/plugins
    	rm -f ~/.config/tmux/plugins/tpm
        ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    fi
  '';
}
