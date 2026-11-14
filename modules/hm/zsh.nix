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

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
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
            source "$HOME/.local/share/zsh-snap/znap.zsh"
            zstyle ':znap:*' repos-dir "$HOME/.zsh-plugins/"

            # Load fzf-tab before the completion system is initialized.
            zstyle ':completion:*' menu no
            zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
            zstyle ':completion:*:descriptions' format '[%d]'
            znap source Aloxaf/fzf-tab
            znap source zsh-users/zsh-completions
            znap source zpm-zsh/clipboard
            znap source arzzen/calc.plugin.zsh

            function completions {
              local sitefuncdir=''${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions
              [[ -f $sitefuncdir/_rustup ]]    || znap fpath _rustup    'rustup completions zsh'
              [[ -f $sitefuncdir/_cargo ]]     || znap fpath _cargo     'rustup completions zsh cargo'
              [[ -f $sitefuncdir/_just ]]      || znap fpath _just      'just --completions zsh'
              [[ -f $sitefuncdir/_watchexec ]] || znap fpath _watchexec 'watchexec --completions zsh'
              [[ -f $sitefuncdir/_atuin ]]     || znap fpath _atuin     'atuin gen-completions --shell zsh'
            }
            completions
            unfunction completions
          '')
          ''
            path=("$HOME/bin" "$HOME/.cargo/bin" "$HOME/.local/bin" $path)
            typeset -U path
            setopt CORRECT
            bindkey -v

            function zsh-refresh-completions {
              local sitefuncdir=''${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions
              rm -f "$sitefuncdir"/_{rustup,cargo,just,watchexec,atuin}
              exec zsh
            }

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
