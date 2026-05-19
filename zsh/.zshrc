# ─── Path ────────────────────────────────────────────────────────────────────

path=(
    "$HOME/.local/bin"
    "$HOME/.local/share/nvim/mason/bin"
    "/Users/marcelosaad/.rd/bin"                 # Rancher Desktop (macOS)
    "/opt/homebrew/opt/mysql-client/bin"          # Homebrew (macOS)
    "${KREW_ROOT:-$HOME/.krew}/bin"
    "$HOME/.cargo/bin"
    "$HOME/.npm-global/bin"
    "$HOME/.opencode/bin"
    $path
)
typeset -U path PATH

# ─── Environment ─────────────────────────────────────────────────────────────

export EDITOR=nvim
export NVM_DIR="$HOME/.nvm"

# ─── History ─────────────────────────────────────────────────────────────────

HISTFILE="$HOME/.zhistory"
HISTSIZE=999
SAVEHIST=1000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# ─── Oh-My-Zsh ───────────────────────────────────────────────────────────────

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="fino"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
source "$ZSH/oh-my-zsh.sh"

# ─── Plugins (system-wide) ───────────────────────────────────────────────────

# Linux (Arch package paths)
[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] \
    && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] \
    && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# macOS (Homebrew paths)
# source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ─── Keybindings ─────────────────────────────────────────────────────────────

# History search with vi-style bindings
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Edit current command line in $EDITOR with Ctrl-V
autoload edit-command-line && zle -N edit-command-line
bindkey '^v' edit-command-line

# vi-style navigation in completion menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# ─── Aliases ─────────────────────────────────────────────────────────────────

alias v=nvim
alias vi=v
alias vim=v
alias batcat=bat
alias k=kubectl
alias b=blackbox
alias ls="eza --icons=always"
alias cd="z"

# kitty-aware ssh (uses the kitty kitten when in a kitty terminal)
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

# ─── Integrations ────────────────────────────────────────────────────────────

# Zoxide (better cd)
eval "$(zoxide init zsh)"

# FZF (fuzzy finder + key bindings)
eval "$(fzf --zsh)"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Per-command fzf preview hooks
_fzf_comprun() {
    local command=$1
    shift
    case "$command" in
        cd)            fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
        export|unset)  fzf --preview "eval 'echo $'{}"                          "$@" ;;
        ssh)           fzf --preview 'dig {}'                                   "$@" ;;
        *)             fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
    esac
}

# NVM (Homebrew path, macOS)
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]                              && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]           && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# uv / cargo env file
[ -r "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# ─── Kubernetes (disabled) ───────────────────────────────────────────────────
# Uncomment when working with clusters again.
# source <(kubectl completion zsh)
#
# source ~/.kube-ps1/kube-ps1.sh
# PROMPT='$(kube_ps1)'$PROMPT
# KUBE_PS1_PREFIX="("
# KUBE_PS1_SUFFIX=")"
# KUBE_PS1_SYMBOL_USE_IMG=true
