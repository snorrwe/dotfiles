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
    plugins = with pkgs; [
      nushellPlugins.formats
    ];
  };
}
