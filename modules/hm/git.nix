{
  pkgs,
  username,
  host,
  inputs,
  ...
}:
{
  programs.git = {
    enable = true;
    userName = "Daniel Kiss";
    userEmail = "littlesnorrboy@gmail.com";
    lfs.enable = true;
    difftastic = {
      enable = true;
      background = "dark";
      display = "inline";
    };
  };
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = "3";
      };
      git = {
        paging = {
          externalDiffCommand = "${pkgs.difftastic}/bin/difft --color=always";
        };
      };
    };
  };
  programs.gh = {
    enable = true;
    settings = {
      editor = "nvim";
    };
    extensions = [
      pkgs.gh-dash
    ];
  };
  programs.gh-dash = {
    enable = true;
    settings = {
    };
  };
}
