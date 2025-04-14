{
  pkgs,
  username,
  host,
  inputs,
  ...
}:
{
  programs.nushell = {
    enable = true;
  };
}
