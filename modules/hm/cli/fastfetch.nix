{
  pkgs,
  username,
  host,
  inputs,
  ...
}:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        size = {
          binaryPrefix = "si";
        };
        separator = "   ";
      };
      modules = [
        "cpu"
        "gpu"
        {
          type = "gpu";
          format = "{3}";
        }
        "memory"
        "swap"
        "disk"
        "break"
        {
          type = "os";
          key = "os";
        }
        {
          type = "kernel";
          key = "kernel";
        }
        "break"
        {
          type = "packages";
          key = "packages";
        }
        {
          type = "shell";
          key = " ";
        }
        {
          type = "terminal";
          key = " ";
        }
        "wm"
        "editor"
        "font"
        "break"
        "datetime"
        "uptime"
        "battery"
      ];
    };
  };
}
