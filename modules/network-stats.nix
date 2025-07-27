{
  pkgs,
  host,
  ...
}:
let
  outdir = "/var/lib/network-stats";
  networkPollScript = pkgs.writeScriptBin "network-stats" ''
    set -euxo pipefail
    OUTFILE="${outdir}/network.json"
    mkdir -p ${outdir}
    if [ ! -f $OUTFILE ]; then
      echo '[]' > $OUTFILE
    fi
    ${pkgs.speedtest-cli}/bin/speedtest --json | ${pkgs.jq}/bin/jq -r '. + {"host": "${host}"}' > /tmp/currentNetwork.json
    ${pkgs.jq}/bin/jq -r '. + [inputs]' $OUTFILE /tmp/currentNetwork.json > /tmp/network-stats.json
    mv /tmp/network-stats.json $OUTFILE
  '';
  weatherPollScript = pkgs.writeScriptBin "wttr" ''
    set -euxo pipefail
    mkdir -p ${outdir}
    OUTFILE="${outdir}/weather.json"
    if [ ! -f $OUTFILE ]; then
      echo '[]' > $OUTFILE
    fi
    ${pkgs.curl}/bin/curl 'wttr.in?format=j2' > /tmp/currentWeather.json
    ${pkgs.jq}/bin/jq -r '. + [inputs]' $OUTFILE /tmp/currentWeather.json > /tmp/weather-stats.json
    mv /tmp/weather-stats.json $OUTFILE
  '';
in
{
  systemd.services.network-stats = {
    enable = true;
    unitConfig = {
      Description = "Poll network speed using speedtest-cli";
    };
    script = "${pkgs.bash}/bin/bash ${networkPollScript}/bin/network-stats";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Restart = "on-failure";
      RestartSec = 1;
    };
    startAt = "*:0/15";
  };
  systemd.services.weather-poll = {
    enable = true;
    unitConfig = {
      Description = "Poll weather";
    };
    script = "${pkgs.bash}/bin/bash ${weatherPollScript}/bin/wttr";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Restart = "on-failure";
      RestartSec = 1;
    };
    startAt = "*:0/15";
  };
}
