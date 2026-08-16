{ pkgs, config, ... }:
let
  inherit (pkgs) sccache jq;

  sccache-local-s3 = pkgs.writeShellScriptBin "sccache" ''
    export SCCACHE_BUCKET="sccache";
    export AWS_ACCESS_KEY_ID="$(${jq}/bin/jq -r .key < ${config.age.secrets.sccache-json.path})"
    export AWS_SECRET_ACCESS_KEY="$(${jq}/bin/jq -r .secret < ${config.age.secrets.sccache-json.path})"
    export AWS_ENDPOINT_URL="https://s3.snorrwe.org"
    export SCCACHE_ENDPOINT="$AWS_ENDPOINT_URL"
    export SCCACHE_REGION="us-east-1"
    export SCCACHE_S3_USE_SSL=true
    exec ${sccache}/bin/sccache $@
  '';
in
{

  age.secrets.sccache-json.file = ../secrets/s3.local.json;
  home = {
    packages = [ sccache-local-s3 ];
    sessionVariables = {
      RUSTC_WRAPPER = sccache-local-s3;
    };
  };
}
