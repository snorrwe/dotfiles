{
  pkgs,
  lib,
  host,
  config,
  ...
}:

let
in
with lib;
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Monaspace Neon:size=12";
      };
      colors = {
        background = "24273add";
        text = "cad3f5ff";
        prompt = "b8c0e0ff";
        placeholder = "8087a2ff";
        input = "cad3f5ff";
        match = "f4dbd6ff";
        selection = "5b6078ff";
        selection-text = "cad3f5ff";
        selection-match = "f4dbd6ff";
        counter = "8087a2ff";
        border = "f4dbd6ff";
      };
    };
  };
}
