{
  flake.modules.homeManager.darwin =
    {
      pkgs,
      inputs,
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
          inputs.kache.packages.${pkgs.stdenv.hostPlatform.system}.default
          visidata
          killall

          sshfs
          python3
        ];
      };

      programs.home-manager.enable = true;
    };
}
