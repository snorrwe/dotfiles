{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    escapeTime = 0;
    focusEvents = true;
    keyMode = "vi";
    prefix = "`";
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          # catppucin config
          set -ogq @catppucin_flavour 'mocha'
          set -ogq @catppuccin_window_status_style "slanted"
          set -ogq @catppuccin_window_text " #W"
          set -ogq @catppuccin_window_current_text " #W #F"
          set -ogq @catppuccin_window_flags "icon"
          set -g status-right "#{E:pane_current_path} #{E:@catppuccin_status_session}"
          set -g status-left ""

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

      # some key-binding changes
      bind x kill-pane
      bind Z previous-layout

      set-option -g detach-on-destroy off

      bind-key p switch-client -l

      set -g status-position top

      bind-key g neww -c "#{pane_current_path}" lazygit
      bind-key y neww -c "#{pane_current_path}" yazi
      bind-key b neww -c "#{pane_current_path}" btop

      unbind s
      bind-key s display-popup -E tmux-select-session

      set-option -g renumber-windows on
    '';
  };
}
