#!/usr/bin/zsh
# ============================================================================
# ACHROMATIC PROMPT
# Pure monochrome ZSH prompt optimized for file navigation
# ============================================================================

# === PROMPT OPTIONS ===
setopt PROMPT_SUBST         # Enable prompt substitution
setopt TRANSIENT_RPROMPT    # Remove right prompt from previous lines

# === COLOR DEFINITIONS (Achromatic Palette) ===
# Using ANSI 256 colors for better terminal compatibility
typeset -A AC
AC[black]=0         # #0a0a0a - background
AC[dark]=236        # #111111 - very dark gray
AC[dim]=240         # #666666 - dimmed
AC[mid]=245         # #888888 - medium
AC[light]=250       # #cccccc - standard text
AC[bright]=254      # #e0e0e0 - important
AC[white]=255       # #ffffff - maximum emphasis

# === HELPER FUNCTIONS ===

# Shorten path: ~/Documents/projects/achromatic -> ~/D/p/achromatic
_achromatic_short_path() {
    local pwd="${PWD/#$HOME/~}"
    local parts=("${(@s:/:)pwd}")
    local len=${#parts[@]}
    local result=""
    
    if (( len <= 3 )); then
        echo "$pwd"
        return
    fi
    
    # Keep first and last 2, shorten middle
    for (( i=1; i<=len; i++ )); do
        if (( i == 1 )); then
            result="${parts[i]}"
        elif (( i == len || i == len-1 )); then
            result="$result/${parts[i]}"
        else
            result="$result/${parts[i]:0:1}"
        fi
    done
    echo "$result"
}

# Git information
_achromatic_git_info() {
    # Check if we're in a git repo
    git rev-parse --is-inside-work-tree &>/dev/null || return
    
    local branch=""
    local status_flags=""
    
    # Get branch name
    branch=$(git symbolic-ref --short HEAD 2>/dev/null) || \
    branch=$(git describe --tags --exact-match 2>/dev/null) || \
    branch=$(git rev-parse --short HEAD 2>/dev/null)
    
    [[ -z "$branch" ]] && return
    
    # Get status flags (fast method)
    local git_status
    git_status=$(git status --porcelain=v1 2>/dev/null)
    
    # Check for various states
    [[ -n $(echo "$git_status" | grep '^.[MD]') ]] && status_flags+="*"   # Modified
    [[ -n $(echo "$git_status" | grep '^[MADRC]') ]] && status_flags+="+" # Staged
    [[ -n $(echo "$git_status" | grep '^??') ]] && status_flags+="?"      # Untracked
    
    # Check ahead/behind
    local ahead_behind
    ahead_behind=$(git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)
    if [[ -n "$ahead_behind" ]]; then
        local ahead=$(echo "$ahead_behind" | cut -f1)
        local behind=$(echo "$ahead_behind" | cut -f2)
        (( ahead > 0 )) && status_flags+=">"
        (( behind > 0 )) && status_flags+="<"
    fi
    
    # Stash indicator
    (( $(git stash list 2>/dev/null | wc -l) > 0 )) && status_flags+="\$"
    
    # Build output
    if [[ -n "$status_flags" ]]; then
        echo "%F{$AC[light]}$branch%f%F{$AC[bright]}$status_flags%f"
    else
        echo "%F{$AC[dim]}$branch%f"
    fi
}

# Execution time tracking
_achromatic_preexec() {
    _cmd_start_time=$EPOCHREALTIME
}

_achromatic_precmd() {
    local exit_code=$?
    _last_exit_code=$exit_code
    
    # Calculate execution time
    if [[ -n "$_cmd_start_time" ]]; then
        local end_time=$EPOCHREALTIME
        local elapsed=$(( end_time - _cmd_start_time ))
        
        if (( elapsed >= 3 )); then
            if (( elapsed >= 60 )); then
                _cmd_duration="$(( elapsed / 60 | 0 ))m$(( elapsed % 60 | 0 ))s"
            else
                _cmd_duration="${elapsed%.*}s"
            fi
        else
            _cmd_duration=""
        fi
        unset _cmd_start_time
    else
        _cmd_duration=""
    fi
}

# Background jobs count
_achromatic_jobs() {
    local job_count=$(jobs -l 2>/dev/null | wc -l)
    (( job_count > 0 )) && echo "%F{$AC[dim]}[$job_count]%f "
}

# SSH indicator
_achromatic_ssh() {
    [[ -n "$SSH_CONNECTION" ]] && echo "%F{$AC[bright]}[ssh]%f "
}

# Root indicator
_achromatic_root() {
    [[ $EUID -eq 0 ]] && echo "%F{$AC[white]}%K{$AC[dim]}[ROOT]%k%f "
}

# Read-only directory indicator
_achromatic_readonly() {
    [[ ! -w "$PWD" ]] && echo "%F{$AC[dim]}[RO]%f "
}

# Virtual environment indicator
_achromatic_venv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_name=$(basename "$VIRTUAL_ENV")
        echo "%F{$AC[dim]}($venv_name)%f "
    fi
}

# === PROMPT ASSEMBLY ===

# Hook functions
autoload -Uz add-zsh-hook
add-zsh-hook preexec _achromatic_preexec
add-zsh-hook precmd _achromatic_precmd

# Build the prompt
_achromatic_build_prompt() {
    local prompt=""
    
    # Line 1: Status indicators and path
    prompt+="\n"  # Breathing room
    prompt+='$(_achromatic_ssh)'
    prompt+='$(_achromatic_root)'
    prompt+='$(_achromatic_readonly)'
    prompt+='$(_achromatic_venv)'
    prompt+='$(_achromatic_jobs)'
    prompt+="%F{$AC[bright]}"'$(_achromatic_short_path)'"%f"
    
    # Git info (if in repo)
    prompt+='$(
        local git_info=$(_achromatic_git_info)
        [[ -n "$git_info" ]] && echo " $git_info"
    )'
    
    # Execution time (if > 3s)
    prompt+='$(
        [[ -n "$_cmd_duration" ]] && echo " %F{'$AC[dim]'}$_cmd_duration%f"
    )'
    
    # Line 2: Prompt character
    prompt+="\n"
    prompt+='%(?.%F{'$AC[light]'}.%F{'$AC[white]'}%K{'$AC[dim]'})>%f%k '
    
    echo "$prompt"
}

# Right prompt (minimal)
_achromatic_build_rprompt() {
    # Show exit code only on failure
    echo '%(?.."[%F{'$AC[dim]'}%?%f]")'
}

# Set prompts
PROMPT=$(_achromatic_build_prompt)
RPROMPT=$(_achromatic_build_rprompt)

# Continuation prompt
PS2="%F{$AC[dim]}...%f "

# Selection prompt (used in select loops)
PS3="%F{$AC[light]}?#%f "

# Debug/trace prompt
PS4="%F{$AC[dim]}+%N:%i>%f "

