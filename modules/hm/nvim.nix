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
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
  };
}
