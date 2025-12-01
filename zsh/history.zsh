#!/usr/bin/zsh
# ============================================================================
# ACHROMATIC HISTORY
# Extended history configuration
# ============================================================================

# === HISTORY FILE ===
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000

# Ensure history directory exists
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"

# === HISTORY OPTIONS ===
setopt EXTENDED_HISTORY         # Record timestamp of command
setopt HIST_EXPIRE_DUPS_FIRST   # Delete duplicates first when trimming
setopt HIST_IGNORE_DUPS         # Ignore consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS     # Remove older duplicate entries
setopt HIST_IGNORE_SPACE        # Ignore commands starting with space
setopt HIST_FIND_NO_DUPS        # Don't show duplicates when searching
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks
setopt HIST_VERIFY              # Show command before executing from history
setopt SHARE_HISTORY            # Share history between sessions
setopt INC_APPEND_HISTORY       # Add commands immediately to history
setopt HIST_NO_STORE            # Don't store history commands

# === HISTORY ALIASES ===
alias h='history -20'
alias hg='history 0 | grep'
alias hc='history -c && echo "History cleared"'

# === EPOCHREALTIME FOR TIMING ===
# Required for prompt execution time tracking
zmodload zsh/datetime

