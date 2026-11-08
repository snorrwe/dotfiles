{
  flake.modules.homeManager.linux =
    {
      pkgs,
      username,
      inputs,
      features,
      config,
      ...
    }:
    let
      inherit (pkgs.lib.lists) optionals;
    in
    {
      imports = [ inputs.agenix.homeManagerModules.default ];

      home = {
        # Home Manager Settings
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "26.11";
        packages =
          with pkgs;
          [
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
          ]
          ++ (optionals features.enableGui [ libnotify ]);
      };

      programs = {
        # Let Home Manager install and manage itself.
        home-manager.enable = true;

        wezterm = {
          enable = features.enableGui;
          enableZshIntegration = true;
          extraConfig = builtins.readFile ../../dotfiles/.wezterm.lua;
          package = inputs.wezterm.packages.${pkgs.stdenv.hostPlatform.system}.default;
        };

        # media player, used by yazi by default
        mpv = {
          enable = features.enableGui;
        };
      };

      age.identityPaths = [
        "${config.home.homeDirectory}/.ssh/id_ed25519"
        "${config.home.homeDirectory}/.ssh/home"
      ];
    };
}
