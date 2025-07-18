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
    config = {
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.updateRefs = true;
      submodule.recurse = false;
      push.recurseSubmodules = "on-demand";
    };
  };
}
