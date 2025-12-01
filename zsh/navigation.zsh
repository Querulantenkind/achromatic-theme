#!/usr/bin/zsh
# ============================================================================
# ACHROMATIC NAVIGATION
# File navigation tools, aliases, and integrations
# ============================================================================

# === ZOXIDE INTEGRATION ===
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh --cmd cd)"
    # Now 'cd' is smart, 'cdi' for interactive selection
fi

# === FZF INTEGRATION ===
if command -v fzf &>/dev/null; then
    # Achromatic color scheme for fzf
    export FZF_DEFAULT_OPTS="
        --color=fg:#cccccc,bg:#0a0a0a,hl:#ffffff
        --color=fg+:#ffffff,bg+:#1a1a1a,hl+:#ffffff
        --color=info:#666666,prompt:#e0e0e0,pointer:#ffffff
        --color=marker:#e0e0e0,spinner:#666666,header:#888888
        --color=border:#2a2a2a,gutter:#0a0a0a
        --height=40%
        --layout=reverse
        --border=sharp
        --margin=0,1
        --prompt='> '
        --pointer='>'
        --marker='*'
        --info=inline
    "
    
    # Use fd if available (faster than find)
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
    
    # File preview with bat if available
    if command -v bat &>/dev/null; then
        export FZF_CTRL_T_OPTS="--preview 'bat --style=plain --color=always --line-range=:100 {} 2>/dev/null || cat {}'"
        export FZF_ALT_C_OPTS="--preview 'eza -la --no-icons --color=always {} 2>/dev/null || ls -la {}'"
    else
        export FZF_CTRL_T_OPTS="--preview 'head -100 {} 2>/dev/null'"
        export FZF_ALT_C_OPTS="--preview 'ls -la {}'"
    fi
    
    # Enable fzf keybindings
    if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
        source /usr/share/fzf/key-bindings.zsh
    fi
    if [[ -f /usr/share/fzf/completion.zsh ]]; then
        source /usr/share/fzf/completion.zsh
    fi
    
    # Custom fzf functions
    
    # fzf cd into directory (recursive)
    fcd() {
        local dir
        dir=$(fd --type d --hidden --follow --exclude .git 2>/dev/null | fzf +m) && cd "$dir"
    }
    
    # fzf open file in $EDITOR
    fe() {
        local file
        file=$(fzf --multi) && ${EDITOR:-vim} "${file[@]}"
    }
    
    # fzf git log browser
    fgl() {
        git log --oneline --color=always | fzf --ansi --preview 'git show --color=always {1}'
    }
    
    # fzf kill process
    fkill() {
        local pid
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
        if [[ -n "$pid" ]]; then
            echo "$pid" | xargs kill -${1:-9}
        fi
    }
    
    # fzf recent directories (from zoxide)
    fz() {
        if command -v zoxide &>/dev/null; then
            local dir
            dir=$(zoxide query -l | fzf) && cd "$dir"
        fi
    }
fi

# === EZA/LS ALIASES ===
if command -v eza &>/dev/null; then
    alias ls='eza --no-icons'
    alias l='eza -la --no-icons --git'
    alias ll='eza -l --no-icons --git'
    alias la='eza -la --no-icons'
    alias lt='eza -la --no-icons --git --tree --level=2'
    alias lS='eza -la --no-icons --git --sort=size'
    alias lm='eza -la --no-icons --git --sort=modified'
    alias lr='eza -la --no-icons --git --sort=modified --reverse'
else
    alias l='ls -lAh --color=auto'
    alias ll='ls -lh --color=auto'
    alias la='ls -lAh --color=auto'
fi

# === DIRECTORY NAVIGATION ===

# Quick parent navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Global aliases for piping
alias -g G='| grep'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g W='| wc -l'

# Directory stack navigation (pushd/popd)
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# Make directory and cd into it
take() {
    mkdir -p "$1" && cd "$1"
}

# Go back to parent directory with name
bd() {
    local target="$1"
    local current="$PWD"
    
    while [[ "$current" != "/" ]]; do
        current=$(dirname "$current")
        if [[ $(basename "$current") == *"$target"* ]]; then
            cd "$current"
            return 0
        fi
    done
    
    echo "No parent directory matching '$target' found"
    return 1
}

# === YAZI FILE MANAGER INTEGRATION ===
if command -v yazi &>/dev/null; then
    # Use yazi and cd to directory on exit
    y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [[ -n "$cwd" ]] && [[ "$cwd" != "$PWD" ]]; then
            cd "$cwd"
        fi
        rm -f -- "$tmp"
    }
fi

# === BAT/CAT ALIASES ===
if command -v bat &>/dev/null; then
    alias cat='bat --style=plain --paging=never'
    alias catn='bat --style=numbers --paging=never'
    alias catf='bat --style=full'
    
    # Achromatic bat theme
    export BAT_THEME="ansi"
fi

# === FD ALIASES ===
if command -v fd &>/dev/null; then
    alias find='fd'
fi

# === RIPGREP ALIASES ===
if command -v rg &>/dev/null; then
    alias grep='rg'
    alias rgi='rg --ignore-case'
    alias rgf='rg --files-with-matches'
fi

# === GIT SHORTCUTS ===
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -20'
alias gco='git checkout'
alias gb='git branch'

# === QUICK EDITS ===
alias zshrc='${EDITOR:-vim} ~/.zshrc'
alias reload='source ~/.zshrc && echo "Reloaded .zshrc"'

# === SAFETY NETS ===
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# === AUTO-LS ON CD ===
# Uncomment if you want automatic listing after cd
# chpwd() {
#     eza -la --no-icons --git 2>/dev/null || ls -lAh --color=auto
# }

