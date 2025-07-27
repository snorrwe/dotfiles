{
  pkgs,
  host,
  username,
  ...
}:
let
  script = pkgs.writeScriptBin "network-stats" ''
    set -euxo pipefail
    OUTFILE="/var/lib/network-stats/out.json"
    mkdir -p /var/lib/network-stats
    if [ ! -f $OUTFILE ]; then
      echo '[]' > $OUTFILE
    fi
    ${pkgs.speedtest-cli}/bin/speedtest --json | ${pkgs.jq}/bin/jq -r '. + {"host": "${host}"}' > /var/lib/network-stats/current.json
    ${pkgs.jq}/bin/jq -r '. + [inputs]' $OUTFILE /var/lib/network-stats/current.json > /tmp/network-stats.json
    mv /tmp/network-stats.json $OUTFILE
  '';
in
{
  systemd.services.network-stats = {
    enable = true;
    unitConfig = {
      Description = "Poll network speed using speedtest-cli";
    };
    script = "${pkgs.bash}/bin/bash ${script}/bin/network-stats";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Restart = "on-failure";
      RestartSec = 1;
    };
    startAt = "*:0/15";
  };
}
