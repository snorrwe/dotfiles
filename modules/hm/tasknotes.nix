{
  pkgs,
  config,
  lib,
  ...
}:
let
  notes_dir = config.notes.dir;

  run_batch = pkgs.writeShellScript "maintain-tasknotes-contexts-batch" ''
    ${pkgs.jq}/bin/jq --unbuffered -cr '.tags | map({(.kind): .}) | add | select((.fs.simple |
    IN("create", "modify")) and (.path.filetype == "file")) | .path.absolute' < /dev/stdin \
    | sort -n | uniq \
    | tee >(cat >&2) \
    | ${pkgs.parallel}/bin/parallel ${config.home.profileDirectory}/bin/obsidian-maintain-subtask-contexts {} ${notes_dir}
  '';
in
{
  options.notes.dir = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/notes";
    description = "Path to the notes dir.";
  };

  config.systemd.user.services.maintain-tasknotes-contexts = {
    Unit = {
      Description = "Maintain Obsidian TaskNotes context properties in project hierarchies";
    };
    Service = {
      ExecStart = pkgs.writeShellScript "maintain-tasknotes-contexts" ''
        #!/usr/bin/env bash
        set -x
        ${pkgs.watchexec}/bin/watchexec --postpone -w ${notes_dir} -e md -d 15s --emit-events-to=json-stdio ${run_batch}
      '';
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
