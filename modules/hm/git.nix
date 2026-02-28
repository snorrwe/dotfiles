{
  pkgs,
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
      merge.ours.driver = true;
      merge.union.driver = true;
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
        log = {
          showWholeGraph = true;
        };
        pagers = [
          {
            externalDiffCommand = "${pkgs.difftastic}/bin/difft --color=always";
          }
        ];
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
