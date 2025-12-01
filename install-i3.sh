#!/bin/bash

# ============================================================================
# ACHROMATIC I3 INSTALLATION SCRIPT
# Automated installation of monochrome i3 configuration
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
BACKUP_DIR="$HOME/.config/backup-achromatic-i3-$(date +%Y%m%d-%H%M%S)"

I3_SOURCE="$SCRIPT_DIR/i3"
I3_CONFIG="$CONFIG_DIR/i3"
I3STATUS_CONFIG="$CONFIG_DIR/i3status"
ROFI_CONFIG="$CONFIG_DIR/rofi"
DUNST_CONFIG="$CONFIG_DIR/dunst"

# === BANNER ===

clear
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║                ACHROMATIC I3 INSTALLER                    ║"
echo "║                Pure Monochrome Configuration              ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# === PRE-INSTALLATION CHECKS ===

print_section "Pre-Installation Checks"

# Check if i3 is installed
if ! command -v i3 &> /dev/null; then
    print_warning "i3 is not installed"
    print_info "Install with: sudo pacman -S i3-wm"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    print_success "i3 is installed"
fi

# Check if required tools are installed
REQUIRED_TOOLS=("i3status" "rofi" "dunst")
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
backup_config "$I3_CONFIG" "i3"
backup_config "$I3STATUS_CONFIG" "i3status"
backup_config "$ROFI_CONFIG" "Rofi"
backup_config "$DUNST_CONFIG" "Dunst"

# === INSTALLATION ===

print_section "Installing Achromatic i3 Configuration"

# Create necessary directories
print_info "Creating configuration directories..."
mkdir -p "$I3_CONFIG"
mkdir -p "$I3STATUS_CONFIG"
mkdir -p "$ROFI_CONFIG"
mkdir -p "$DUNST_CONFIG"

# Copy i3 configuration
if [ -f "$I3_SOURCE/config/config" ]; then
    cp "$I3_SOURCE/config/config" "$I3_CONFIG/config"
    print_success "Installed: i3 configuration"
else
    print_error "Source file not found: i3 config"
    exit 1
fi

# Copy i3status configuration
if [ -f "$I3_SOURCE/i3status/config" ]; then
    cp "$I3_SOURCE/i3status/config" "$I3STATUS_CONFIG/config"
    print_success "Installed: i3status configuration"
else
    print_error "Source file not found: i3status config"
    exit 1
fi

# Copy Rofi configuration
if [ -f "$I3_SOURCE/rofi/config.rasi" ] && [ -f "$I3_SOURCE/rofi/abyss.rasi" ]; then
    cp "$I3_SOURCE/rofi/config.rasi" "$ROFI_CONFIG/config.rasi"
    cp "$I3_SOURCE/rofi/abyss.rasi" "$ROFI_CONFIG/abyss.rasi"
    print_success "Installed: Rofi configuration"
else
    print_error "Source files not found: Rofi config.rasi or abyss.rasi"
    exit 1
fi

# Copy Dunst configuration
if [ -f "$I3_SOURCE/dunst/dunstrc" ]; then
    cp "$I3_SOURCE/dunst/dunstrc" "$DUNST_CONFIG/dunstrc"
    print_success "Installed: Dunst configuration"
else
    print_error "Source file not found: Dunst config"
    exit 1
fi

# === POST-INSTALLATION ===

print_section "Post-Installation"

# Set correct permissions
[ -f "$I3_CONFIG/config" ] && chmod 644 "$I3_CONFIG/config"
[ -f "$I3STATUS_CONFIG/config" ] && chmod 644 "$I3STATUS_CONFIG/config"
[ -f "$ROFI_CONFIG/config.rasi" ] && chmod 644 "$ROFI_CONFIG/config.rasi"
[ -f "$ROFI_CONFIG/abyss.rasi" ] && chmod 644 "$ROFI_CONFIG/abyss.rasi"
[ -f "$DUNST_CONFIG/dunstrc" ] && chmod 644 "$DUNST_CONFIG/dunstrc"

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

verify_file "$I3_CONFIG/config" "i3 config"
verify_file "$I3STATUS_CONFIG/config" "i3status config"
verify_file "$ROFI_CONFIG/config.rasi" "Rofi config"
verify_file "$ROFI_CONFIG/abyss.rasi" "Rofi theme"
verify_file "$DUNST_CONFIG/dunstrc" "Dunst config"

if [ $VERIFICATION_FAILED -eq 1 ]; then
    print_error "Verification failed - some files are missing"
    exit 1
fi

# === COMPLETION ===

print_section "i3 Installation Complete"

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║            ACHROMATIC I3 INSTALLED SUCCESSFULLY           ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

print_success "All i3 configurations have been installed"
print_info "Backup location: $BACKUP_DIR"

echo ""
echo "Next steps:"
echo ""
echo "  1. Log out of your current session"
echo "  2. Select 'i3' at the login screen"
echo "  3. Log in to experience Achromatic"
echo ""
echo "Or, if you're already in i3:"
echo ""
echo "  1. Reload configuration: \$mod + Shift + R"
echo "  2. Or restart i3: \$mod + Shift + E"
echo ""

print_info "To restore your previous configuration:"
echo "  cp -r $BACKUP_DIR/* $CONFIG_DIR/"
echo ""

print_info "For troubleshooting, see: README.md"
echo ""

# === OPTIONAL: RESTART COMPONENTS ===

if pgrep -x "i3" > /dev/null; then
    echo ""
    read -p "You're running i3. Restart i3 now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Restarting i3..."
        i3-msg reload
        print_success "Reloaded: i3 configuration"
        
        # Restart Dunst
        if pgrep -x "dunst" > /dev/null; then
            killall dunst
            dunst &
            print_success "Restarted: Dunst"
        fi
        
        echo ""
        print_success "All components restarted"
    fi
fi

echo ""
print_success "i3 installation script completed"
echo ""

exit 0

