{ pkgs, config, ... }: {
  systemd.user.services.maintain-tasknotes-contexts = {
    Unit = {
      Description = ''
        Maintains Obsidian TaskNotes context properties in project hierarchies
      '';
    };
    Service = {
      ExecStart = pkgs.writeShellScript "maintain-tasknotes-contexts" ''
        #!/usr/bin/env bash
        set -x
        ${pkgs.watchexec}/bin/watchexec -w ${config.home.homeDirectory}/notes/ -e md -d 15s --only-emit-events | \
            ${pkgs.jq}/bin/jq --unbuffered -cr '.tags | map({(.kind): .}) | add | select((.fs.simple | IN("create", "modify")) and (.path.filetype == "file")) | .path.absolute' | \
            ${pkgs.parallel}/bin/parallel ${config.home.profileDirectory}/bin/obsidian-maintain-subtask-contexts {}

      '';
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
