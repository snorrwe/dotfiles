{
  flake.modules.homeManager.common =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        FZF_DEFAULT_COMMAND = "fd --type f -u";
        FZF_DEFAULT_OPTS = "--height 60% --layout=reverse";
      };

      home.packages = [ pkgs.zsh-completions ];

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        plugins = [
          {
            name = "fzf-tab";
            src = pkgs.zsh-fzf-tab;
            file = "share/fzf-tab/fzf-tab.plugin.zsh";
          }
          # Load after fzf-tab so its ZLE widgets aren't overwritten.
          {
            name = "zsh-autosuggestions";
            src = pkgs.zsh-autosuggestions;
            file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
          }
        ];
        syntaxHighlighting.enable = true;

        shellAliases = {
          jt = "just test";
          jb = "just build";
          jc = "just check";
          l = "ls -CF";
          icat = "wezterm imgcat";
          cdtmp = "cd $(mktemp -d)";
          cdtemp = "cdtmp";
          pushtmp = "pushd $(mktemp -d)";
          pushtemp = "pushtmp";
          v = "nvim";
          da = "direnv allow";
          dr = "direnv reload";
          e = "eza --git --group-directories-first --icons";
          ea = "e -al";
          la = "ea";
          ll = "e -alF";
          tree = "eza --tree";
          gp = "git pull --autostash";
          gs = "git status";
          gl = "git log";
          gd = "git diff";
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          ls = "ls --color=auto";
          grep = "grep --color=auto";
          fgrep = "fgrep --color=auto";
          egrep = "egrep --color=auto";
        }
        // lib.optionalAttrs config.programs.tmux.enable {
          tmux = "direnv exec / tmux";
        };

        initContent = lib.mkMerge [
          (lib.mkBefore ''
            fpath+=(${pkgs.zsh-completions}/share/zsh/site-functions)
            zstyle ':completion:*' menu no
            zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
            zstyle ':completion:*:descriptions' format '[%d]'
          '')
          ''
            path=("$HOME/bin" "$HOME/.cargo/bin" "$HOME/.local/bin" $path)
            typeset -U path
            setopt CORRECT
            bindkey -v

            # Home Manager handles fzf, direnv, atuin and zoxide integrations.
            eval "$(starship init zsh)"
            if (( $+commands[sesh] )); then
              eval "$(sesh completion zsh)"
            fi

            function lg {
              export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
              command lazygit "$@"
              if [[ -f $LAZYGIT_NEW_DIR_FILE ]]; then
                builtin cd "$(< "$LAZYGIT_NEW_DIR_FILE")"
                rm -f "$LAZYGIT_NEW_DIR_FILE"
              fi
            }

            function t {
              local sessions
              sessions=$(command tmux ls 2>/dev/null)
              if [[ -n $sessions ]]; then
                command tmux new-session -A -s "''${sessions%%:*}"
              else
                command tmux
              fi
            }
          ''
        ];
      };
    };
}
