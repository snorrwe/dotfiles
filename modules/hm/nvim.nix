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
  home.activation.setupNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -d ~/.config/nvim ]]; then
        ${pkgs.git}/bin/git clone https://github.com/snorrwe/nvim-config ~/.config/nvim
    fi
  '';
}
