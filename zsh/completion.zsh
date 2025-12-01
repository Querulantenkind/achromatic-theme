#!/usr/bin/zsh
# ============================================================================
# ACHROMATIC COMPLETION
# Advanced completion system configuration
# ============================================================================

# === INITIALIZE COMPLETION SYSTEM ===
autoload -Uz compinit
# Only regenerate .zcompdump once per day
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# === COMPLETION OPTIONS ===
setopt COMPLETE_IN_WORD     # Complete from both ends of cursor
setopt ALWAYS_TO_END        # Move cursor to end after completion
setopt AUTO_MENU            # Show completion menu on tab press
setopt AUTO_LIST            # List choices on ambiguous completion
setopt AUTO_PARAM_SLASH     # Add trailing slash to directories
setopt NO_MENU_COMPLETE     # Don't autoselect first completion entry
setopt NO_FLOW_CONTROL      # Disable flow control (^S/^Q)
setopt PATH_DIRS            # Perform path search for commands with slashes
setopt COMPLETE_ALIASES     # Complete aliases

# === COMPLETION STYLING ===
zstyle ':completion:*' menu select                              # Interactive menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive
zstyle ':completion:*' list-colors ''                           # No colors (monochrome)
zstyle ':completion:*' group-name ''                            # Group completions
zstyle ':completion:*' verbose yes                              # Verbose completions
zstyle ':completion:*' squeeze-slashes true                     # Strip extra slashes

# Formatting
zstyle ':completion:*:descriptions' format '%F{240}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{240}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format '%F{240}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{240}-- no matches --%f'

# Completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# Directory completion
zstyle ':completion:*' special-dirs true                        # Include . and ..
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Man page completion
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections true

# SSH/SCP completion
zstyle ':completion:*:(ssh|scp|rsync):*' hosts ${(s: :)${(f)"$(cat ~/.ssh/known_hosts 2>/dev/null | cut -d' ' -f1 | tr ',' '\n' | cut -d']' -f1 | sed 's/\[//')"}}
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'

# Process completion
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'

# === FZF-TAB (if installed) ===
if [[ -f /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ]]; then
    source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
    
    # Disable sort when completing options
    zstyle ':completion:complete:*:options' sort false
    
    # Preview for files and directories
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -la --no-icons --color=always $realpath 2>/dev/null || ls -la $realpath'
    zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --style=plain --color=always ${realpath} 2>/dev/null || cat ${realpath} 2>/dev/null || eza -la --no-icons --color=always ${realpath} 2>/dev/null'
    
    # Use fzf colors
    zstyle ':fzf-tab:*' fzf-flags --color=fg:#cccccc,bg:#0a0a0a,hl:#ffffff,fg+:#ffffff,bg+:#1a1a1a,hl+:#ffffff,info:#666666,prompt:#e0e0e0,pointer:#ffffff,marker:#e0e0e0,spinner:#666666
fi

# === ADDITIONAL COMPLETERS ===
zstyle ':completion:*' completer _extensions _complete _approximate

# Allow approximate completions (typo tolerance)
zstyle ':completion:*:approximate:*' max-errors 2 numeric

