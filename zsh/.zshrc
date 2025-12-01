#!/usr/bin/zsh
# ============================================================================
# ACHROMATIC ZSH CONFIGURATION
# Pure monochrome shell configuration
# ============================================================================

# === DIRECTORY ===
ACHROMATIC_ZSH_DIR="${ZDOTDIR:-$HOME}/.config/achromatic-zsh"

# === LOAD MODULES ===
[[ -f "$ACHROMATIC_ZSH_DIR/history.zsh" ]] && source "$ACHROMATIC_ZSH_DIR/history.zsh"
[[ -f "$ACHROMATIC_ZSH_DIR/completion.zsh" ]] && source "$ACHROMATIC_ZSH_DIR/completion.zsh"
[[ -f "$ACHROMATIC_ZSH_DIR/navigation.zsh" ]] && source "$ACHROMATIC_ZSH_DIR/navigation.zsh"
[[ -f "$ACHROMATIC_ZSH_DIR/prompt.zsh" ]] && source "$ACHROMATIC_ZSH_DIR/prompt.zsh"

# === BASIC OPTIONS ===
setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # Push directories onto stack
setopt PUSHD_IGNORE_DUPS    # No duplicates in dir stack
setopt PUSHD_SILENT         # Don't print dir stack
setopt CORRECT              # Command correction
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell
setopt NO_BEEP              # No beeping

# === KEY BINDINGS ===
bindkey -e                          # Emacs keybindings
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[H' beginning-of-line    # Home
bindkey '^[[F' end-of-line          # End
bindkey '^[[3~' delete-char         # Delete
bindkey '^[[1;5C' forward-word      # Ctrl+Right
bindkey '^[[1;5D' backward-word     # Ctrl+Left

# === EXTERNAL PLUGINS (if installed) ===

# zsh-autosuggestions
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#d4a017'
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# zsh-syntax-highlighting (load last)
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    # Monochrome syntax highlighting
    ZSH_HIGHLIGHT_STYLES[default]='fg=#cccccc'
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#666666,underline'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#ffffff,bold'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=#d4a017'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=#e0e0e0'
    ZSH_HIGHLIGHT_STYLES[function]='fg=#e0e0e0'
    ZSH_HIGHLIGHT_STYLES[command]='fg=#f6d600'
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=#ffffff,bold'
    ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#888888'
    ZSH_HIGHLIGHT_STYLES[path]='fg=#cccccc,underline'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#aaaaaa'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#aaaaaa'
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#aaaaaa'
    ZSH_HIGHLIGHT_STYLES[redirection]='fg=#888888'
    ZSH_HIGHLIGHT_STYLES[comment]='fg=#555555'
fi

# fast-syntax-highlighting (alternative, load if zsh-syntax-highlighting not found)
if [[ ! -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
   [[ -f /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]]; then
    source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi

# zsh-history-substring-search
if [[ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=#f6d600,bold'
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=#666666'
fi

# === FASTFETCH GREETING ===
# Display system info on new interactive shells
if [[ -o interactive ]] && command -v fastfetch &>/dev/null; then
    fastfetch
fi
# Note: To run the glitch animation manually, use: achromatic-glitch

# === PATH ===
# Ensure ~/.local/bin is in PATH for achromatic-glitch command
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

# Add your custom configurations below this line
# ============================================================================

