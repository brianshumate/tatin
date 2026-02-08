# ~/.bashrc — interactive shells only
[[ $- != *i* ]] && return

TERM=xterm-256color
export TERM

# ---------- History ----------
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend checkwinsize

# ---------- Debian chroot ----------
if [[ -z ${debian_chroot:-} && -r /etc/debian_chroot ]]; then
    debian_chroot=$(< /etc/debian_chroot)
fi

# ---------- Prompt ----------

if [[ ${color_prompt:-} == yes ]]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# xterm title
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
esac

unset color_prompt

# ---------- Core tools ----------
if command -v dircolors >/dev/null; then
    eval "$(dircolors -b "$HOME/.dircolors" 2>/dev/null || dircolors -b)"
    alias ls='ls --color=auto'
fi

# ---------- Aliases ----------
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases

# ---------- Bash completion ----------
if ! shopt -oq posix; then
    for f in /usr/share/bash-completion/bash_completion /etc/bash_completion; do
        [[ -r $f ]] && source "$f" && break
    done
fi

# ---------- PATH ----------
# Never overwrite PATH — only extend it
path_prepend() { [[ ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"; }
path_append()  { [[ ":$PATH:" != *":$1:"* ]] && PATH="$PATH:$1"; }

path_append "$HOME/.local/bin"
path_append "$HOME/.bun/bin"
path_append "$HOME/.opencode/bin"
path_append "$HOME/.claude/bin"

export PATH

# ---------- Mise ----------
# Activate mise once, interactive shells only
if command -v mise >/dev/null; then
    eval "$(mise activate bash)"
fi

# Lazy-load mise completions (only when completion is used)
_mise_completion_loaded=0
_mise_complete() {
    [[ $_mise_completion_loaded -eq 0 ]] && {
        eval "$(mise completion bash)"
        _mise_completion_loaded=1
    }
}
complete -o default -F _mise_complete mise

export MISE_TRUSTED_CONFIG_PATHS="$HOME:$HOME/.config/mise:$HOME/work"

# ---------- Convenience ----------
alias claude='claude --dangerously-skip-permissions'

mise trust .
