# ==========================================================================
# 1. SYSTEM ENVIRONMENT & PATHS
# ==========================================================================
. "$HOME/.local/bin/env"

# Docker Desktop command completions
fpath=(/Users/rad7bg/.docker/completions $fpath)
if [[ -r /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]]; then
  source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
fi

# Python Path Configurations
export CLOUDSDK_PYTHON="/opt/homebrew/opt/python@3.12/bin/python3.12"

# ==========================================================================
# 2. SHELL HISTORY MANAGEMENT (Clean & De-duplicated)
# ==========================================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Do not clutter history with commands that only end the shell.
zshaddhistory() {
  local command_line="${1%%$'\n'}"
  command_line="${command_line##[[:space:]]#}"
  case "$command_line" in
    exit|q) return 1 ;;
  esac
  return 0
}

# ==========================================================================
# 3. ALIASES (Cloud Dev & Keyboard-Centric Quick-Keys)
# ==========================================================================
# System Shortcuts
alias c='clear'
alias v='nvim'
alias q='exit'

# Python & Tool Shortcuts
alias python="python3"
alias pip="pip3"

# Git Quick-Keys
alias lg="git status"
alias gp="git push"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate"
alias gco="git checkout"
alias gb="git branch"
alias gc="git commit"
alias gcm="git commit -m"
alias gst="git status --short --branch"
alias k="kubectl"
alias tf="terraform"

# Cloud and project helpers.
gcp-projects() {
  gcloud projects list --format='table(projectId, name, projectNumber)'
}

gcp-use() {
  if [[ -z "$1" ]]; then
    print "Usage: gcp-use PROJECT_ID"
    return 1
  fi
  gcloud config set project "$1" && export CLOUDSDK_CORE_PROJECT="$1" GOOGLE_CLOUD_PROJECT="$1"
}

kctx() {
  if [[ -z "$1" ]]; then
    kubectl config current-context
  else
    kubectl config use-context "$1"
  fi
}

kns() {
  if [[ -z "$1" ]]; then
    kubectl config view --minify --output 'jsonpath={..namespace}'
    print
  else
    kubectl config set-context --current --namespace="$1"
  fi
}

mkvenv() {
  python3 -m venv .venv && source .venv/bin/activate
}

venv() {
  if [[ ! -f .venv/bin/activate ]]; then
    print "No .venv found in the current directory"
    return 1
  fi
  source .venv/bin/activate
}

export PIP_DISABLE_PIP_VERSION_CHECK=1
export PIP_DEFAULT_TIMEOUT=100

# ==========================================================================
# 4. PLUGINS & INTERACTIVE FEATURES (Homebrew Installed)
# ==========================================================================
# Autocomplete suggestions and code syntax highlighting
if (( $+commands[brew] )); then
  brew_prefix="$(brew --prefix)"
  [[ -r "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Activate Fuzzy Finder Interactivity (Press Ctrl+R to try it!) [source: 5]
# Run `brew install fzf` if this doesn't run [source: 2, 5]
export FZF_CTRL_R_OPTS='--height=40% --layout=reverse --border=rounded --prompt="history > "'
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# Native completions for the cloud and infrastructure tools used most often.
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

# ==========================================================================
# 5. ERGONOMIC VI-MODE COMMAND EDITING
# ==========================================================================
bindkey -v                      # Native Vi-motion commands in terminal prompt
export KEYTIMEOUT=1             # Keeps jk mode switching responsive

# Map jk to escape Zsh command insert mode.
bindkey -M viins 'jk' vi-cmd-mode

# Keep editing keys predictable in Vi insert mode.
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^[[3~' delete-char

# Change the cursor so Insert and command modes are visually distinct.
_set_vi_cursor() {
  if [[ "$KEYMAP" == vicmd ]]; then
    print -n '\e[2 q'
  else
    print -n '\e[6 q'
  fi
}
zle-keymap-select() { _set_vi_cursor }
zle-line-init() { _set_vi_cursor }
zle -N zle-keymap-select
zle -N zle-line-init

# ==========================================================================
# 6. EXTERNAL TOOLS INITIALIZATION (Zero Duplicates)
# ==========================================================================
# Zoxide: smarter directory navigation.
zoxide_path="$(command -v zoxide 2>/dev/null)"
if [[ -n "$zoxide_path" && -x "$zoxide_path" ]]; then
  eval "$("$zoxide_path" init zsh)"
fi

# Starship prompt.
(( $+commands[starship] )) && eval "$(starship init zsh)"
