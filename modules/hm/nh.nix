{
  pkgs,
  username,
  host,
  inputs,
  ...
}:
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
    flake = toString inputs.self;
  };
}
