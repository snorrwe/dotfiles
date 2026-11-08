{
  flake.modules.homeManager.darwin =
    {
      pkgs,
      username,
      ...
    }:
    {
      home = {
        username = "${username}";
        homeDirectory = "/Users/${username}";
        stateVersion = "26.05";
        packages = with pkgs; [
          ninja
          cmake
          gzip
          nodejs_22
          curl

          pkg-config
          sccache
          visidata
          killall

          sshfs
          python3
        ];
      };

      programs.home-manager.enable = true;
    };
}
