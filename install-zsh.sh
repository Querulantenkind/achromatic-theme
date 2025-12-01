#!/bin/bash

# ============================================================================
# ACHROMATIC ZSH INSTALLATION SCRIPT
# Automated installation of monochrome ZSH configuration
# ============================================================================

set -e  # Exit on error

# === COLOR DEFINITIONS FOR OUTPUT ===

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# === HELPER FUNCTIONS ===

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_section() {
    echo ""
    echo -e "${BLUE}=== $1 ===${NC}"
    echo ""
}

# === CHECK IF RUNNING AS ROOT ===

if [[ $EUID -eq 0 ]]; then
   print_error "This script should NOT be run as root"
   print_info "Please run as your regular user"
   exit 1
fi

# === VARIABLES ===

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
ZSH_SOURCE="$SCRIPT_DIR/zsh"
ZSH_CONFIG="$CONFIG_DIR/achromatic-zsh"
BACKUP_DIR="$HOME/.config/backup-achromatic-zsh-$(date +%Y%m%d-%H%M%S)"

# === BANNER ===

clear
echo ""
echo "+---------------------------------------------------------+"
echo "|                                                         |"
echo "|              ACHROMATIC ZSH INSTALLER                   |"
echo "|         Pure Monochrome Shell Configuration             |"
echo "|                                                         |"
echo "+---------------------------------------------------------+"
echo ""

# === PRE-INSTALLATION CHECKS ===

print_section "Pre-Installation Checks"

# Check if ZSH is installed
if ! command -v zsh &> /dev/null; then
    print_error "ZSH is not installed"
    print_info "Install with: sudo pacman -S zsh"
    exit 1
else
    print_success "ZSH is installed: $(zsh --version)"
fi

# Check if ZSH is the default shell
if [[ "$SHELL" != *"zsh"* ]]; then
    print_warning "ZSH is not your default shell"
    print_info "Change with: chsh -s $(which zsh)"
fi

# Check for recommended tools
RECOMMENDED_TOOLS=("zoxide" "fzf" "eza" "fd" "bat" "rg")
MISSING_TOOLS=()

for tool in "${RECOMMENDED_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        MISSING_TOOLS+=("$tool")
    else
        print_success "Found: $tool"
    fi
done

if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    print_warning "Recommended tools not found: ${MISSING_TOOLS[*]}"
    print_info "Install with: sudo pacman -S ${MISSING_TOOLS[*]}"
    echo ""
    read -p "Continue anyway? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        exit 1
    fi
fi

# Check for optional ZSH plugins
print_section "Checking ZSH Plugins"

PLUGIN_PATHS=(
    "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    "/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
    "/usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
)

for plugin_path in "${PLUGIN_PATHS[@]}"; do
    plugin_name=$(basename "$(dirname "$plugin_path")")
    if [[ -f "$plugin_path" ]]; then
        print_success "Found plugin: $plugin_name"
    else
        print_info "Optional plugin not found: $plugin_name"
    fi
done

echo ""
print_info "Install plugins with: sudo pacman -S zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search"
print_info "For fzf-tab, use AUR: yay -S fzf-tab-git"

# === BACKUP EXISTING CONFIGURATIONS ===

print_section "Backing Up Existing Configurations"

mkdir -p "$BACKUP_DIR"
print_info "Backup directory: $BACKUP_DIR"

# Backup function
backup_config() {
    local source=$1
    local name=$2
    
    if [ -d "$source" ] || [ -f "$source" ]; then
        cp -r "$source" "$BACKUP_DIR/" 2>/dev/null || true
        print_success "Backed up: $name"
        return 0
    else
        print_info "No existing config: $name"
        return 1
    fi
}

# Backup existing configs
backup_config "$HOME/.zshrc" ".zshrc"
backup_config "$ZSH_CONFIG" "achromatic-zsh"

# === INSTALLATION ===

print_section "Installing Achromatic ZSH Configuration"

# Create configuration directory
print_info "Creating configuration directory..."
mkdir -p "$ZSH_CONFIG"
mkdir -p "$HOME/.local/share/zsh"  # For history
mkdir -p "$HOME/.cache/zsh"        # For completion cache

# Copy configuration files
ZSH_FILES=("prompt.zsh" "navigation.zsh" "completion.zsh" "history.zsh")

for file in "${ZSH_FILES[@]}"; do
    if [ -f "$ZSH_SOURCE/$file" ]; then
        cp "$ZSH_SOURCE/$file" "$ZSH_CONFIG/$file"
        print_success "Installed: $file"
    else
        print_error "Source file not found: $file"
        exit 1
    fi
done

# Install .zshrc
if [ -f "$ZSH_SOURCE/.zshrc" ]; then
    cp "$ZSH_SOURCE/.zshrc" "$HOME/.zshrc"
    print_success "Installed: .zshrc"
else
    print_error "Source file not found: .zshrc"
    exit 1
fi

# === POST-INSTALLATION ===

print_section "Post-Installation"

# Set correct permissions
chmod 644 "$ZSH_CONFIG"/*.zsh
chmod 644 "$HOME/.zshrc"

print_success "File permissions set"

# === VERIFICATION ===

print_section "Verifying Installation"

VERIFICATION_FAILED=0

verify_file() {
    local file=$1
    local name=$2
    
    if [ -f "$file" ]; then
        print_success "Verified: $name"
    else
        print_error "Missing: $name"
        VERIFICATION_FAILED=1
    fi
}

verify_file "$HOME/.zshrc" ".zshrc"
verify_file "$ZSH_CONFIG/prompt.zsh" "prompt.zsh"
verify_file "$ZSH_CONFIG/navigation.zsh" "navigation.zsh"
verify_file "$ZSH_CONFIG/completion.zsh" "completion.zsh"
verify_file "$ZSH_CONFIG/history.zsh" "history.zsh"

if [ $VERIFICATION_FAILED -eq 1 ]; then
    print_error "Verification failed - some files are missing"
    exit 1
fi

# === COMPLETION ===

print_section "ZSH Installation Complete"

echo ""
echo "+---------------------------------------------------------+"
echo "|                                                         |"
echo "|          ACHROMATIC ZSH INSTALLED SUCCESSFULLY          |"
echo "|                                                         |"
echo "+---------------------------------------------------------+"
echo ""

print_success "All ZSH configurations have been installed"
print_info "Backup location: $BACKUP_DIR"

echo ""
echo "Configuration files installed to:"
echo "  ~/.zshrc                    Main configuration"
echo "  ~/.config/achromatic-zsh/   Module files"
echo ""

echo "Recommended packages to install:"
echo ""
echo "  Core navigation tools:"
echo "    sudo pacman -S zoxide fzf eza fd bat ripgrep yazi"
echo ""
echo "  ZSH plugins:"
echo "    sudo pacman -S zsh-autosuggestions zsh-syntax-highlighting"
echo "    sudo pacman -S zsh-history-substring-search"
echo "    yay -S fzf-tab-git  (AUR)"
echo ""

print_info "To restore your previous configuration:"
echo "  cp $BACKUP_DIR/.zshrc ~/.zshrc"
echo ""

# === RELOAD PROMPT ===

echo ""
read -p "Reload ZSH configuration now? (Y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    print_info "Starting new ZSH session..."
    exec zsh
fi

echo ""
print_success "ZSH installation script completed"
echo ""

exit 0

