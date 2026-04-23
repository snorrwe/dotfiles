{
  pkgs,
  username,
  host,
  inputs,
  features,
  lib,
  ...
}:
{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "Daniel Kiss";
          email = "littlesnorrboy@gmail.com";
        };
        merge = {
          ours.driver = true;
          union.driver = true;
        };
        safe.directory = lib.lists.optionals features.enableAgents [
          "/var/agent/*"
        ];
        push.autoSetupRemote = true;
      };
      lfs.enable = true;
    };
    difftastic = {
      enable = true;
      options = {
        background = "dark";
        display = "inline";
      };
      git.enable = true;
    };
    lazygit = {
      enable = true;
      settings = {
        gui = {
          nerdFontsVersion = "3";
        };
        git = {
          log = {
            showWholeGraph = false;
          };
          pagers = [
            {
              externalDiffCommand = "${pkgs.difftastic}/bin/difft --color=always";
            }
          ];
        };
      };
    };
    gh = {
      enable = true;
      settings = {
        editor = "nvim";
      };
      extensions = [
        pkgs.gh-dash
      ];
    };
    gh-dash = {
      enable = true;
      settings = {
        smartFilteringAtLaunch = false;
        pager = {
          diff = "${pkgs.delta}/bin/delta -s --paging always";
        };
      };
    };
  };
}
