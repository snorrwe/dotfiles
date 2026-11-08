{
  flake.modules.homeManager.common = _: {
    programs.parallel = {
      enable = true;
      will-cite = true;
    };
  };
}
