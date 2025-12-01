#!/bin/bash

# ============================================================================
# ACHROMATIC INSTALLATION SCRIPT
# Automated installation of monochrome Hyprland configuration
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
BACKUP_DIR="$HOME/.config/backup-achromatic-$(date +%Y%m%d-%H%M%S)"

HYPRLAND_SOURCE="$SCRIPT_DIR/hyprland"
HYPRLAND_CONFIG="$CONFIG_DIR/hypr"
WAYBAR_CONFIG="$CONFIG_DIR/waybar"
ROFI_CONFIG="$CONFIG_DIR/rofi"
MAKO_CONFIG="$CONFIG_DIR/mako"

# === BANNER ===

clear
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║                    ACHROMATIC INSTALLER                   ║"
echo "║                Pure Monochrome Configuration              ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# === PRE-INSTALLATION CHECKS ===

print_section "Pre-Installation Checks"

# Check if Hyprland is installed
if ! command -v Hyprland &> /dev/null; then
    print_warning "Hyprland is not installed"
    print_info "Install with: sudo pacman -S hyprland"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    print_success "Hyprland is installed"
fi

# Check if required tools are installed
REQUIRED_TOOLS=("waybar" "rofi" "mako")
MISSING_TOOLS=()

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        MISSING_TOOLS+=("$tool")
    fi
done

if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    print_warning "Missing tools: ${MISSING_TOOLS[*]}"
    print_info "Install with: sudo pacman -S ${MISSING_TOOLS[*]}"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    print_success "All required tools are installed"
fi

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

# Perform backups
backup_config "$HYPRLAND_CONFIG" "Hyprland"
backup_config "$WAYBAR_CONFIG" "Waybar"
backup_config "$ROFI_CONFIG" "Rofi"
backup_config "$MAKO_CONFIG" "Mako"

# === INSTALLATION ===

print_section "Installing Achromatic Configuration"

# Create necessary directories
print_info "Creating configuration directories..."
mkdir -p "$HYPRLAND_CONFIG"
mkdir -p "$WAYBAR_CONFIG"
mkdir -p "$ROFI_CONFIG"
mkdir -p "$MAKO_CONFIG"

# Copy Hyprland configuration
if [ -f "$HYPRLAND_SOURCE/config/hyprland.conf" ]; then
    cp "$HYPRLAND_SOURCE/config/hyprland.conf" "$HYPRLAND_CONFIG/hyprland.conf"
    print_success "Installed: Hyprland configuration"
else
    print_error "Source file not found: hyprland.conf"
    exit 1
fi

# Copy Waybar configuration
if [ -f "$HYPRLAND_SOURCE/waybar/config" ] && [ -f "$HYPRLAND_SOURCE/waybar/style.css" ]; then
    cp "$HYPRLAND_SOURCE/waybar/config" "$WAYBAR_CONFIG/config"
    cp "$HYPRLAND_SOURCE/waybar/style.css" "$WAYBAR_CONFIG/style.css"
    print_success "Installed: Waybar configuration"
else
    print_error "Source files not found: Waybar config or style.css"
    exit 1
fi

# Copy Rofi configuration
if [ -f "$HYPRLAND_SOURCE/rofi/config.rasi" ] && [ -f "$HYPRLAND_SOURCE/rofi/abyss.rasi" ]; then
    cp "$HYPRLAND_SOURCE/rofi/config.rasi" "$ROFI_CONFIG/config.rasi"
    cp "$HYPRLAND_SOURCE/rofi/abyss.rasi" "$ROFI_CONFIG/abyss.rasi"
    print_success "Installed: Rofi configuration"
else
    print_error "Source files not found: Rofi config.rasi or abyss.rasi"
    exit 1
fi

# Copy Mako configuration
if [ -f "$HYPRLAND_SOURCE/mako/config" ]; then
    cp "$HYPRLAND_SOURCE/mako/config" "$MAKO_CONFIG/config"
    print_success "Installed: Mako configuration"
else
    print_error "Source file not found: Mako config"
    exit 1
fi

# === POST-INSTALLATION ===

print_section "Post-Installation"

# Set correct permissions
chmod 644 "$HYPRLAND_CONFIG/hyprland.conf"
chmod 644 "$WAYBAR_CONFIG/config"
chmod 644 "$WAYBAR_CONFIG/style.css"
chmod 644 "$ROFI_CONFIG/config.rasi"
chmod 644 "$ROFI_CONFIG/abyss.rasi"
chmod 644 "$MAKO_CONFIG/config"

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

verify_file "$HYPRLAND_CONFIG/hyprland.conf" "Hyprland config"
verify_file "$WAYBAR_CONFIG/config" "Waybar config"
verify_file "$WAYBAR_CONFIG/style.css" "Waybar stylesheet"
verify_file "$ROFI_CONFIG/config.rasi" "Rofi config"
verify_file "$ROFI_CONFIG/abyss.rasi" "Rofi theme"
verify_file "$MAKO_CONFIG/config" "Mako config"

if [ $VERIFICATION_FAILED -eq 1 ]; then
    print_error "Verification failed - some files are missing"
    exit 1
fi

# === COMPLETION ===

print_section "Installation Complete"

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║              ACHROMATIC INSTALLED SUCCESSFULLY            ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

print_success "All configurations have been installed"
print_info "Backup location: $BACKUP_DIR"

echo ""
echo "Next steps:"
echo ""
echo "  1. Log out of your current session"
echo "  2. Select 'Hyprland' at the login screen"
echo "  3. Log in to experience Achromatic"
echo ""
echo "Or, if you're already in Hyprland:"
echo ""
echo "  1. Reload configuration: Super + Shift + R"
echo "  2. Or restart Hyprland: Super + Shift + Alt + Q"
echo ""

print_info "To restore your previous configuration:"
echo "  cp -r $BACKUP_DIR/* $CONFIG_DIR/"
echo ""

print_info "For troubleshooting, see: README.md"
echo ""

# === OPTIONAL: RESTART COMPONENTS ===

if pgrep -x "Hyprland" > /dev/null; then
    echo ""
    read -p "You're running Hyprland. Restart components now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Restarting components..."
        
        # Restart Waybar
        if pgrep -x "waybar" > /dev/null; then
            killall waybar
            waybar &
            print_success "Restarted: Waybar"
        fi
        
        # Restart Mako
        if pgrep -x "mako" > /dev/null; then
            killall mako
            mako &
            print_success "Restarted: Mako"
        fi
        
        # Reload Hyprland config
        hyprctl reload
        print_success "Reloaded: Hyprland configuration"
        
        echo ""
        print_success "All components restarted"
    fi
fi

echo ""
print_success "Installation script completed"
echo ""

exit 0