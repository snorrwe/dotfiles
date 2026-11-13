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
      kacheBin =
        if config.kache.enableRemote then kache-with-credentials else kache;
    in
    {
      options.kache = {
        enableRemote = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Use the S3 remote with agenix credentials. Disable for local-only environments such as agent-box.";
        };
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
        age.secrets.kache-json = lib.mkIf config.kache.enableRemote {
          file = ../_secrets/s3.local.json;
        };
        xdg.configFile."kache/config.toml".source =
          if config.kache.enableRemote then hostConfig else containerConfig;
        home.file = lib.mkIf (config.kache.enableRemote && features.enableDistrobox) (
          lib.mapAttrs' (_: container: {
            name = "${lib.removePrefix "~/" container.home}/.config/kache/config.toml";
            value.source = containerConfig;
          }) config.programs.distrobox.containers
        );
        home = {
          packages = [ kacheBin ];
          sessionVariables.RUSTC_WRAPPER = "${kacheBin}/bin/kache";
        };
      };
    };
}
