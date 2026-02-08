# ----------------------------------------------------------------------------
# PATHS
# ----------------------------------------------------------------------------
# Never overwrite PATH — only extend it
path_prepend() { [[ ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"; }
path_append()  { [[ ":$PATH:" != *":$1:"* ]] && PATH="$PATH:$1"; }

path_append "$HOME/.local/bin"
path_append "$HOME/.opencode/bin"
path_append "$HOME/.claude/bin"

export PATH

# ----------------------------------------------------------------------------
# ZSH
# ----------------------------------------------------------------------------

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="dracula"

# ZSH highlighting colors
source $HOME/.zsh/zsh-syntax-highlighting.sh

zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 4

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
    git
    tmux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ----------------------------------------------------------------------------
# User configuration
# ----------------------------------------------------------------------------

export MANPATH="/usr/local/man:$MANPATH"
export EDITOR=/bin/vim
export PAGER="/bin/less"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export SHELL="/bin/zsh"
export VISUAL="/bin/vim"
export ZDOTDIR="$HOME/.zsh"
export MAILCONF=$HOME/.mutt
export LESSOPEN="|-$HOME/bin/lesspipe %s"
export LESS=-R

# ----------------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------------

alias ls='eza --icons $@'

# Docker shiz
alias dockstopall='docker stop $(docker ps -a -q)'
alias dockrmall='docker rm $(docker ps -a -q)'
alias dockpsa="docker ps -a"
alias dockprune='docker system prune --all --force && docker buildx prune --all --force && docker image prune --all --force && docker volume prune --all --force && docker network prune --force && docker container prune --force'

# ----------------------------------------------------------------------------
# System
# ----------------------------------------------------------------------------

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Mise
eval "$(mise activate zsh)"

# FZF
FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
export FZF_DEFAULT_OPTS
source <(fzf --zsh)

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vi'
else
  export EDITOR='vim'
fi

# pet
zle -N _pet-select
stty -ixon
bindkey '^s' _pet-select

# Rust / cargo
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# gpg-agent
GPG_TTY="$(tty)"
SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export GPG_TTY SSH_AUTH_SOCK
gpgconf --launch gpg-agent

# ssh agent
eval "$(ssh-agent)"

# direnv
# eval "$(direnv hook zsh)"

# Starship
# eval "$(starship init zsh)"
eval "$(starship init bash)"

# Terminal titles
preexec() { print -Pn "\e]0;$1%~\a" }

# argh
unalias gm

# Initialize zsh completions (added by deno install script)
autoload -Uz compinit
compinit

# opencode
export PATH=/Users/brian/.opencode/bin:$PATH

mise trust .
