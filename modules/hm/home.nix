{
  flake.modules.homeManager.linux =
    {
      pkgs,
      username,
      inputs,
      config,
      ...
    }:
    {
      imports = [ inputs.agenix.homeManagerModules.default ];

      home = {
        # Home Manager Settings
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "26.11";
        packages = with pkgs; [
          go
          ninja
          cmake
          gzip
          nodejs_22
          curl

          pkg-config
          visidata
          killall
          podman-compose
          docker-compose

          clang
          clang-tools

          flamegraph

          sshfs
          python3
        ];
      };

      programs = {
        # Let Home Manager install and manage itself.
        home-manager.enable = true;
        zsh.enable = true;
      };

      age.identityPaths = [
        "${config.home.homeDirectory}/.ssh/id_ed25519"
        "${config.home.homeDirectory}/.ssh/home"
      ];
    };
}
