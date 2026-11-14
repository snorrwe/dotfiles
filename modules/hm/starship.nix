{
  flake.modules.homeManager.common =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
        settings = {
          format = lib.concatStrings [
            "$username"
            "$hostname"
            "$directory"
            "$vcsh"
            "$fossil_branch"
            "$fossil_metrics"
            "$git_branch"
            "$git_commit"
            "$git_state"
            "$git_metrics"
            "$git_status"
            "$hg_branch"
            "$hg_state"
            "$nix_shell"
            "$conda"
            "$meson"
            "$spack"
            "$memory_usage"
            "$aws"
            "$gcloud"
            "$openstack"
            "$azure"
            "$nats"
            "$direnv"
            "$env_var"
            "$mise"
            "$crystal"
            "$custom"
            "$sudo"
            "$cmd_duration"
            "$line_break"
            "$jobs"
            "$battery"
            "$time"
            "$status"
            "$os"
            "$container"
            "$netns"
            "$shell"
            "$character"
          ];
          add_newline = true;
          hostname.ssh_only = false;
          git_metrics.disabled = false;
          status.disabled = false;
          sudo.disabled = false;
          direnv = {
            disabled = false;
            allowed_msg = "✓";
            format = "[$symbol$allowed$loaded]($style) ";
            denied_msg = "x";
            loaded_msg = "󰡴";
            not_allowed_msg = "x";
            unloaded_msg = "󱦟";
          };
        };
      };

    };
}
