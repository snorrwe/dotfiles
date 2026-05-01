{
  pkgs,
  lib,
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
    extraPackages = with pkgs; [
      viu
      chafa
      tree-sitter
      gnutar
      curl
      wget
      python3
      python3Packages.pynvim
      ruby
    ];
  };
}
