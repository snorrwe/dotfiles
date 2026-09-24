{
  pkgs,
  config,
  lib,
  host,
  ...
}:
let
  inherit (pkgs) sccache jq;

  sccache-local-s3 = pkgs.writeShellScriptBin "sccache" ''
    export SCCACHE_BUCKET="sccache";
    export AWS_ACCESS_KEY_ID="$(${jq}/bin/jq -r .key < ${config.age.secrets.sccache-json.path})"
    export AWS_SECRET_ACCESS_KEY="$(${jq}/bin/jq -r .secret < ${config.age.secrets.sccache-json.path})"
    export AWS_ENDPOINT_URL="${config.sccache.s3Url}"
    export SCCACHE_ENDPOINT="$AWS_ENDPOINT_URL"
    export SCCACHE_REGION="us-east-1"
    export SCCACHE_S3_USE_SSL=${lib.escapeShellArg (if (builtins.substring 0 5 config.sccache.s3Url) == "https" then "true" else "false")}
    export SCCACHE_BASE_DIR="''${SCCACHE_BASE_DIR:-${config.home.homeDirectory}}"
    exec ${sccache}/bin/sccache "$@"
  '';
in
{
  options.sccache.s3Url = lib.mkOption {
    type = lib.types.str;
    default = "https://s3.snorrwe.org";
    description = "URL of the sccache S3 endpoint";
  };

  config.sccache.s3Url = lib.mkIf (host == "danipc") "http://s3.local";

  config.age.secrets.sccache-json.file = ../secrets/s3.local.json;
  config.home = {
    packages = [ sccache-local-s3 ];
    sessionVariables = {
      RUSTC_WRAPPER = "${sccache-local-s3}/bin/sccache";
      CARGO_INCREMENTAL = "0";
      SCCACHE_BASE_DIR = config.home.homeDirectory;
    };
  };
}
