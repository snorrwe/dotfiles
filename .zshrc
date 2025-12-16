source $HOME/.local/share/zsh-snap/znap.zsh
zstyle ':znap:*' repos-dir $HOME/.zsh-plugins/

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# offer to correct mispelled commands
setopt CORRECT

# enable vi keybindings
bindkey -v

function register_path {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            export PATH="$1:$PATH"
    esac
}

register_path "$HOME/bin"
register_path "$HOME/.cargo/bin"
register_path "$HOME/.local/bin"


export VISUAL="nvim"
export EDITOR="$VISUAL"

# https://github.com/Aloxaf/fzf-tab/issues/482
# load fzf-tab before other plugins
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
znap source Aloxaf/fzf-tab

znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
znap source zpm-zsh/clipboard
znap source arzzen/calc.plugin.zsh

function aliases {
    alias lg=lazygit
    alias jt='just test'
    alias ll='ls -alF'
    alias la='ls -Al'
    alias l='ls -CF'
    alias icat='wezterm imgcat'
    alias cdtmp='cd $(mktemp -d)'
    alias cdtemp='cdtmp'
    alias pushtmp='pushd $(mktemp -d)'
    alias pushtemp='pushtmp'
    # enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi
}

aliases
unset aliases

function completions() {
    # znap fpath _kubectl 'kubectl completion  zsh'
    znap fpath _rustup  'rustup  completions zsh'
    znap fpath _cargo   'rustup  completions zsh cargo'
    znap fpath _just   'just --completions zsh'
    znap fpath _watchexec 'watchexec --completions zsh'
    znap fpath _atuin 'atuin gen-completions --shell zsh'
}

completions
unset completions

if type yazi > /dev/null ; then
    function yy() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        trap "rm -f -- $tmp" EXIT
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi
    }
fi

if type fzf > /dev/null ; then
    export FZF_DEFAULT_COMMAND="fd --type f -u"
    export FZF_DEFAULT_OPTS="--height 60% --layout=reverse"
    znap eval fzf "fzf --zsh"
fi
if type direnv > /dev/null; then
    znap eval direnv "direnv hook zsh"
    alias tmux='direnv exec / tmux'
    alias da='direnv allow'
fi
alias t='if [[ -n $(pgrep tmux) ]]; then tmux a; else systemd-run --user --scope tmux new-session; fi'
if type starship > /dev/null ; then
    znap eval starship "starship init zsh"
fi
if type atuin > /dev/null ; then
    znap eval atuin "atuin init zsh"
fi
if type zoxide > /dev/null ; then
    znap eval zoxide "zoxide init zsh"
fi
if type sccache > /dev/null ; then
    export RUSTC_WRAPPER=$(which sccache)
fi

if type eza > /dev/null ; then
    alias e='eza --git --group-directories-first --icons'
    alias ea='e -al'
    alias la=ea
    alias ll='e -alF'
    alias tree='eza --tree'
fi

if type git > /dev/null ; then
    alias gp='git pull --autostash'
    alias gs='git status'
    alias gl='git log'
    alias gd='git diff'
fi
