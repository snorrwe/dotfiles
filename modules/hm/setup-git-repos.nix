{ pkgs, lib, ... }:
{
  home.activation.setupNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -d ~/.config/nvim ]]; then
        ${pkgs.git}/bin/git clone https://github.com/snorrwe/nvim-config ~/.config/nvim
    fi
    if [[ ! -d ~/.config/tmux/plugins/tpm/ ]]; then
        mkdir -p ~/.config/tmux/plugins
        ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    fi
  '';
}
