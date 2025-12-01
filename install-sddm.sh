#!/bin/bash

# ============================================================================
# ACHROMATIC SDDM INSTALLATION SCRIPT
# Automated installation of monochrome SDDM login theme
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

if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root (use sudo)"
   print_info "Please run: sudo ./install-sddm.sh"
   exit 1
fi

# === VARIABLES ===

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDDM_THEMES_DIR="/usr/share/sddm/themes"
SDDM_CONFIG="/etc/sddm.conf"
SDDM_CONFIG_DIR="/etc/sddm.conf.d"

THEME_SOURCE="$SCRIPT_DIR/sddm/achromatic"
THEME_DEST="$SDDM_THEMES_DIR/achromatic"

# === BANNER ===

clear
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║              ACHROMATIC SDDM INSTALLER                    ║"
echo "║              Pure Monochrome Login Theme                 ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# === PRE-INSTALLATION CHECKS ===

print_section "Pre-Installation Checks"

# Check if SDDM is installed
if ! command -v sddm &> /dev/null; then
    print_warning "SDDM is not installed"
    print_info "Install with: sudo pacman -S sddm"
    exit 1
else
    print_success "SDDM is installed"
fi

# Check if theme source exists
if [ ! -d "$THEME_SOURCE" ]; then
    print_error "Theme source not found: $THEME_SOURCE"
    exit 1
else
    print_success "Theme source found"
fi

# === BACKUP EXISTING THEME ===

print_section "Backing Up Existing Theme"

if [ -d "$THEME_DEST" ]; then
    BACKUP_DIR="${THEME_DEST}.backup-$(date +%Y%m%d-%H%M%S)"
    cp -r "$THEME_DEST" "$BACKUP_DIR" 2>/dev/null || true
    print_success "Backed up existing theme to: $BACKUP_DIR"
else
    print_info "No existing achromatic theme to backup"
fi

# === INSTALLATION ===

print_section "Installing Achromatic SDDM Theme"

# Create themes directory if it doesn't exist
mkdir -p "$SDDM_THEMES_DIR"
print_info "Themes directory: $SDDM_THEMES_DIR"

# Copy theme
if [ -d "$THEME_SOURCE" ]; then
    cp -r "$THEME_SOURCE" "$THEME_DEST"
    print_success "Installed theme to: $THEME_DEST"
else
    print_error "Source theme directory not found"
    exit 1
fi

# Set correct permissions
chmod -R 755 "$THEME_DEST"
print_success "Set theme permissions"

# === CONFIGURE SDDM ===

print_section "Configuring SDDM"

# Check if config file exists
if [ -f "$SDDM_CONFIG" ]; then
    # Backup config
    cp "$SDDM_CONFIG" "${SDDM_CONFIG}.backup-$(date +%Y%m%d-%H%M%S)"
    print_success "Backed up SDDM config"
    
    # Check if [Theme] section exists
    if grep -q "^\[Theme\]" "$SDDM_CONFIG"; then
        # Update existing theme setting
        if grep -q "^Current=" "$SDDM_CONFIG"; then
            sed -i 's/^Current=.*/Current=achromatic/' "$SDDM_CONFIG"
            print_success "Updated theme setting in SDDM config"
        else
            # Add Current= line after [Theme]
            sed -i '/^\[Theme\]/a Current=achromatic' "$SDDM_CONFIG"
            print_success "Added theme setting to SDDM config"
        fi
    else
        # Add [Theme] section at the end
        echo "" >> "$SDDM_CONFIG"
        echo "[Theme]" >> "$SDDM_CONFIG"
        echo "Current=achromatic" >> "$SDDM_CONFIG"
        print_success "Added [Theme] section to SDDM config"
    fi
elif [ -d "$SDDM_CONFIG_DIR" ]; then
    # Use conf.d directory
    CONFIG_FILE="$SDDM_CONFIG_DIR/achromatic.conf"
    echo "[Theme]" > "$CONFIG_FILE"
    echo "Current=achromatic" >> "$CONFIG_FILE"
    print_success "Created theme config in: $CONFIG_FILE"
else
    # Create new config file
    echo "[Theme]" > "$SDDM_CONFIG"
    echo "Current=achromatic" >> "$SDDM_CONFIG"
    print_success "Created new SDDM config file"
fi

# === VERIFICATION ===

print_section "Verifying Installation"

VERIFICATION_FAILED=0

verify_file() {
    local file=$1
    local name=$2
    
    if [ -f "$file" ] || [ -d "$file" ]; then
        print_success "Verified: $name"
    else
        print_error "Missing: $name"
        VERIFICATION_FAILED=1
    fi
}

verify_file "$THEME_DEST" "Theme directory"
verify_file "$THEME_DEST/metadata.desktop" "Theme metadata"
verify_file "$THEME_DEST/Main.qml" "Main theme file"

if [ $VERIFICATION_FAILED -eq 1 ]; then
    print_error "Verification failed - some files are missing"
    exit 1
fi

# === COMPLETION ===

print_section "SDDM Installation Complete"

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║        ACHROMATIC SDDM THEME INSTALLED SUCCESSFULLY       ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

print_success "SDDM theme has been installed and configured"
print_info "Theme location: $THEME_DEST"
print_info "SDDM config: $SDDM_CONFIG"

echo ""
echo "Next steps:"
echo ""
echo "  1. The theme will be active on your next login"
echo "  2. To test immediately, you can restart SDDM:"
echo "     sudo systemctl restart sddm"
echo ""
echo "  Note: Restarting SDDM will log you out"
echo ""

print_info "To restore your previous theme:"
echo "  Check backups in: $SDDM_THEMES_DIR"
echo ""

print_success "SDDM installation script completed"
echo ""

exit 0

