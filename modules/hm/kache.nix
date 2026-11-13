{ inputs, ... }:
{
  flake.modules.homeManager.kache =
    {
      pkgs,
      config,
      lib,
      features,
      ...
    }:
    let
      kache = inputs.kache.packages.${pkgs.stdenv.hostPlatform.system}.default;
      hostConfig = pkgs.writeText "kache-config.toml" ''
        [cache]
        local_max_size = ${builtins.toJSON config.kache.localCacheSize}

        [cache.remote]
        type = "s3"
        bucket = "sccache"
        region = "us-east-1"
        endpoint = ${builtins.toJSON config.kache.s3Url}
      '';
      containerConfig = pkgs.writeText "kache-container-config.toml" ''
        [cache]
        local_max_size = ${builtins.toJSON config.kache.localCacheSize}
        local_only = true
      '';
      kache-with-credentials = pkgs.writeShellScriptBin "kache" ''
        if [ -n "''${CONTAINER_ID:-}" ]; then
          exec ${kache}/bin/kache "$@"
        fi
        export KACHE_S3_ACCESS_KEY="$(${pkgs.jq}/bin/jq -r .key < ${config.age.secrets.kache-json.path})"
        export KACHE_S3_SECRET_KEY="$(${pkgs.jq}/bin/jq -r .secret < ${config.age.secrets.kache-json.path})"
        exec ${kache}/bin/kache "$@"
      '';
    in
    {
      options.kache = {
        s3Url = lib.mkOption {
          type = lib.types.str;
          default = "https://s3.snorrwe.org";
          description = "URL of the Kache S3 endpoint";
        };
        localCacheSize = lib.mkOption {
          type = lib.types.ints.positive;
          default = 32212254720; # 30 GiB
          description = "Maximum size of the local Kache store in bytes.";
        };
      };
      config = {
        kache.s3Url = lib.mkIf features.enableLocalNetwork "http://s3.local";
        age.secrets.kache-json.file = ../_secrets/s3.local.json;
        xdg.configFile."kache/config.toml".source = hostConfig;
        home.file = lib.mkIf features.enableDistrobox (
          lib.mapAttrs' (_: container: {
            name = "${lib.removePrefix "~/" container.home}/.config/kache/config.toml";
            value.source = containerConfig;
          }) config.programs.distrobox.containers
        );
        home = {
          packages = [ kache-with-credentials ];
          sessionVariables = {
            RUSTC_WRAPPER = "${kache-with-credentials}/bin/kache";
          };
        };
      };
    };
}
