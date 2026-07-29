{ pkgs, config, ... }:
let
  run_batch = pkgs.writeShellScript "maintain-tasknotes-contexts-batch" ''
    ${pkgs.jq}/bin/jq --unbuffered -cr '.tags | map({(.kind): .}) | add | select((.fs.simple |
    IN("create", "modify")) and (.path.filetype == "file")) | .path.absolute' < /dev/stdin \
    | sort -n | uniq \
    | tee >(cat >&2) \
    | ${pkgs.parallel}/bin/parallel ${config.home.profileDirectory}/bin/obsidian-maintain-subtask-contexts {}
  '';
in
{
  systemd.user.services.maintain-tasknotes-contexts = {
    Unit = {
      Description = "Maintain Obsidian TaskNotes context properties in project hierarchies";
    };
    Service = {
      ExecStart = pkgs.writeShellScript "maintain-tasknotes-contexts" ''
        #!/usr/bin/env bash
        set -x
        ${pkgs.watchexec}/bin/watchexec --postpone -w ${config.home.homeDirectory}/notes/ -e md -d 15s --emit-events-to=json-stdio ${run_batch}
      '';
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
