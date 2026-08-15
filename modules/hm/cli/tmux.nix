{ pkgs, ... }:
{
  programs = {
    sesh = {
      enable = true;
      enableTmuxIntegration = true;
      enableAlias = true;
    };
    fzf.tmux.enableShellIntegration = true;
    tmux = {
      enable = true;
      mouse = true;
      escapeTime = 0;
      focusEvents = true;
      keyMode = "vi";
      prefix = "`";
      baseIndex = 1;
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = dotbar;
          extraConfig = ''
            set -g @tmux-dotbar-position top
            set -g @tmux-dotbar-bold-status false
            set -g @tmux-dotbar-bold-current-window true

            set -g @tmux-dotbar-bg "#1e1e2e"
            set -g @tmux-dotbar-fg "#585b70"
            set -g @tmux-dotbar-fg-current "#cdd6f4"
            set -g @tmux-dotbar-fg-session "#9399b2"
            set -g @tmux-dotbar-fg-prefix "#cba6f7"

            set -g @tmux-dotbar-session-position "right"
            set -g @tmux-dotbar-justify "left"
            set -g @tmux-dotbar-window-status-format " #{window_index} #{window_name} "
          '';
        }
        vim-tmux-navigator
        tmux-fzf
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-dir '$HOME/.local/share/tmux/resurrect/'
            set -g @resurrect-strategy-nvim 'session'
          '';
        }
        sensible
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
          '';
        }
      ];
      sensibleOnTop = true;
      extraConfig = ''
        # screen mode
        set -g default-terminal "screen-256color"
        # ensure colors render correctly
        set-option -sa terminal-overrides ",xterm*:Tc"
        # Set new panes to open in current directory
        bind c new-window -c "#{pane_current_path}"
        bind % split-window -c "#{pane_current_path}"
        bind '"' split-window -h -c "#{pane_current_path}"

        # don't rename windows automatically
        set-option -g allow-rename off

        # copy to system clipboard
        set -g set-clipboard on
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
        bind -T copy-mode y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

        bind x kill-pane

        set-option -g detach-on-destroy off

        bind-key p switch-client -l

        set -g status-position top

        bind-key g neww -c "#{pane_current_path}" lazygit
        bind-key y neww -c "#{pane_current_path}" yazi
        bind-key b neww -c "#{pane_current_path}" btop

        set-option -g renumber-windows on

        # resize the pane
        bind-key -r J resize-pane -D 3
        bind-key -r K resize-pane -U 3
        bind-key -r H resize-pane -L 3
        bind-key -r L resize-pane -R 3

        # open a new scratch session
        bind-key -r k new-session -A -s scratch -c $HOME

        set -g extended-keys on
        set -g extended-keys-format csi-u
      '';
    };
  };
}
