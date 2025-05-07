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
      submodule.recurse = true;
      push.recurseSubmodules = "on-demand";
    };
  };
}
