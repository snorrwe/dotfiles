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
    settings = {
      user = {
        name = "Daniel Kiss";
        email = "littlesnorrboy@gmail.com";
      };
    };
    lfs.enable = true;
  };
  programs.difftastic = {
    enable = true;
    options = {
      background = "dark";
      display = "inline";
    };
    git.enable = true;
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
      smartFilteringAtLaunch = false;
      pager = {
        diff = "${pkgs.delta}/bin/delta -s --paging always";
      };
    };
  };
}
