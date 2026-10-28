# ==========================================================================
# 1. SYSTEM ENVIRONMENT & PATHS
# ==========================================================================
. "$HOME/.local/bin/env"

# Docker Desktop Command CLI Completions
fpath=(/Users/rad7bg/.docker/completions $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit

# Python Path Configurations
export CLOUDSDK_PYTHON="/opt/homebrew/opt/python@3.12/bin/python3.12"

# ==========================================================================
# 2. SHELL HISTORY MANAGEMENT (Clean & De-duplicated)
# ==========================================================================
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # Record timestamps of commands [source: 2]
setopt HIST_EXPIRE_DUPS_FIRST    # Expire oldest duplicate commands first [source: 2]
setopt HIST_IGNORE_DUPS          # Do not write duplicate commands consecutively to history [source: 2]
setopt HIST_FIND_NO_DUPS         # Do not display duplicate records when searching [source: 2]
setopt HIST_REDUCE_BLANKS        # Trim excess whitespace from commands [source: 2]

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

# ==========================================================================
# 4. PLUGINS & INTERACTIVE FEATURES (Homebrew Installed)
# ==========================================================================
# Autocomplete suggestions & Code Syntax Highlighting
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Activate Fuzzy Finder Interactivity (Press Ctrl+R to try it!) [source: 5]
# Run `brew install fzf` if this doesn't run [source: 2, 5]
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh 
elif command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)" 
fi

# ==========================================================================
# 5. ERGONOMIC VI-MODE COMMAND EDITING
# ==========================================================================
bindkey -v                      # Native Vi-motion commands in terminal prompt
export KEYTIMEOUT=1             # Removes standard mode switching delay [source: 12]

# Map 'jk' to escape Zsh command insert mode (Matches your Neovim setting!)
bindkey -M viins 'jk' vi-cmd-mode

# ==========================================================================
# 6. EXTERNAL TOOLS INITIALIZATION (Zero Duplicates)
# ==========================================================================
# Zoxide: Smarter directory jump tool [source: 1]
eval "$(zoxide init zsh)" 

# Starship: High-contrast status indicator prompt [source: 7]
eval "$(starship init zsh)" 
