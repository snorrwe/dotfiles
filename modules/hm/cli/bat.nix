{
  flake.modules.homeManager.cli = { pkgs, ... }: {
    # colorful, syntax highlighted cat alternative
    programs.bat = {
      enable = true;
      config = {
        theme = "Coldark-Dark";
      };
    };
  };
}
