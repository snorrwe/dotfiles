source $HOME/zsh-snap/znap.zsh

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

. "$HOME/.cargo/env"

function register_path {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            export PATH="$1:$PATH"
    esac
}

register_path "$HOME/bin"
register_path "/usr/local/go/bin"
register_path "$HOME/go/bin"
register_path "$HOME/.local/bin"
register_path "$HOME/.fly/bin"

eval "$(zoxide init zsh)"

export VISUAL="nvim"
export EDITOR="$VISUAL"

[ -f $HOME/.cargo/bin/sccache ] && export RUSTC_WRAPPER=$HOME/.cargo/bin/sccache
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig${PKG_CONFIG_PATH:+":${PKG_CONFIG_PATH}"}"

znap eval fzf "fzf --zsh"
znap eval direnv "direnv hook zsh"
znap eval starship "starship init zsh"
znap eval atuin "atuin init zsh"
znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
znap source zpm-zsh/clipboard
znap source arzzen/calc.plugin.zsh

function config() {
    (
    cd "$HOME/dotfiles/";
    /usr/bin/git $@
    )
}

function aliases {
    alias lg=lazygit
    alias cs='config status'
    alias jt='just test'
    alias ll='ls -alF'
    alias la='ls -Al'
    alias l='ls -CF'
    alias icat='wezterm imgcat'
    alias cdtmp='cd $(mktemp -d)'
    alias pushtmp='pushd $(mktemp -d)'
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
}

completions
unset completions

bindkey -v
