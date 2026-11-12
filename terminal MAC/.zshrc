# ==========================================================================
# 1. SYSTEM ENVIRONMENT & PATHS
# ==========================================================================
. "$HOME/.local/bin/env"

# Docker Desktop command completions
fpath=(/Users/rad7bg/.docker/completions $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit

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
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# ==========================================================================
# 3. ALIASES (Cloud Dev & Keyboard-Centric Quick-Keys)
# ==========================================================================
# System Shortcuts
alias c='clear'
alias v='nvim'

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
  [[ -r "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
    source "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -r "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Activate Fuzzy Finder Interactivity (Press Ctrl+R to try it!) [source: 5]
# Run `brew install fzf` if this doesn't run [source: 2, 5]
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

# Search history using the text already typed, including partial words such as
# "git c". Up and Down cycle through matching commands in every vi keymap.
typeset -a _history_matches
typeset _history_search_query=''
typeset _history_search_index=0

_history_substring_search() {
  local direction="$1"
  local history_line

  if [[ -z "$_history_search_query" || "$BUFFER" != "${_history_matches[_history_search_index]}" ]]; then
    _history_search_query="$BUFFER"
    _history_search_index=0
    _history_matches=()
    [[ -z "$_history_search_query" ]] && { zle "$direction"; return; }
    while IFS= read -r history_line; do
      [[ "$history_line" == *"$_history_search_query"* ]] && _history_matches+=("$history_line")
    done < <(fc -ln -r 1)
  fi

  (( ${#_history_matches} == 0 )) && return
  if [[ "$direction" == 'up-line-or-history' ]]; then
    (( _history_search_index++ ))
    (( _history_search_index > ${#_history_matches} )) && _history_search_index=${#_history_matches}
  else
    (( _history_search_index-- ))
    (( _history_search_index < 1 )) && _history_search_index=1
  fi
  BUFFER="${_history_matches[_history_search_index]}"
  CURSOR=${#BUFFER}
}

_history_substring_search_up() { _history_substring_search up-line-or-history }
_history_substring_search_down() { _history_substring_search down-line-or-history }
zle -N _history_substring_search_up
zle -N _history_substring_search_down
for keymap in emacs viins vicmd; do
  bindkey -M "$keymap" '^[[A' _history_substring_search_up
  bindkey -M "$keymap" '^[[B' _history_substring_search_down
done

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
