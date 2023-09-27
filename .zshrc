source $HOME/zsh-snap/znap.zsh

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

color_prompt=yes
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

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
register_path "/usr/local/go"
register_path "/home/linuxbrew/.linuxbrew/bin"
register_path "/home/linuxbrew/.linuxbrew/sbin"
register_path "$HOME/go/bin"
register_path "$HOME/.local/bin"
register_path "$HOME/.rvm/bin"
register_path "$HOME/.fly/bin"

export DENO_INSTALL="/home/snorrwe/.deno"
register_path "$DENO_INSTALL/bin" 

eval "$(zoxide init zsh)"

export VISUAL="nvim"
export EDITOR="$VISUAL"

[ -f $HOME/.cargo/bin/sccache ] && export RUSTC_WRAPPER=$HOME/.cargo/bin/sccache
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig${PKG_CONFIG_PATH:+":${PKG_CONFIG_PATH}"}"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh


znap eval direnv "direnv hook zsh"
znap eval starship "starship init zsh"
znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
znap source joshskidmore/zsh-fzf-history-search
znap source zpm-zsh/clipboard
znap source arzzen/calc.plugin.zsh

function aliases {
    alias lg=lazygit
    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    alias cs='config status -uno'
    alias lcs='lazygit -g=$HOME/.cfg/ -w=$HOME'
    alias jt='just test'
    alias ll='ls -alF'
    alias la='ls -Al'
    alias l='ls -CF'
    alias icat='kitty +kitten icat'
    alias jc='just --choose'
    alias cdtmp='cd $(mktemp -d)'
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
    znap fpath _kubectl 'kubectl completion  zsh'
    znap fpath _rustup  'rustup  completions zsh'
    znap fpath _cargo   'rustup  completions zsh cargo'
    znap fpath _just   'just --completions zsh'
}

completions
unset completions
