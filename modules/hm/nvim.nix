{
  pkgs,
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
}
