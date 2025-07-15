{
  pkgs,
  lib,
  username,
  host,
  inputs,
  ...

}:
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
  };
  # clone the nvim config repo
  # no, it's not reproducible, but I don't need it to be
  # For a while I managed it a git submodule, but it's sort-of a pain in the ass
  home.activation.setupNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -d ~/.config/nvim ]]; then
        rm -f ~/.config/nvim
        ${pkgs.git}/bin/git clone https://github.com/snorrwe/nvim-config ~/.config/nvim
    fi
  '';
}
