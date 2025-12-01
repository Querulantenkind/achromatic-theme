#!/bin/bash

# ============================================================================
# ACHROMATIC PLASMA 6 INSTALLATION SCRIPT
# Automated installation of monochrome KDE Plasma configuration
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
PLASMA_SOURCE="$SCRIPT_DIR/plasma"
BACKUP_DIR="$HOME/.config/backup-achromatic-plasma-$(date +%Y%m%d-%H%M%S)"

THEME_ID="org.achromatic.desktop"
COLOR_SCHEME="Achromatic"

# Destination directories
DEST_LOOKANDFEEL="$HOME/.local/share/plasma/look-and-feel"
DEST_COLORS="$HOME/.local/share/color-schemes"

# === BANNER ===

clear
echo ""
echo "========================================================================"
echo "                                                                        "
echo "                    ACHROMATIC PLASMA 6 INSTALLER                       "
echo "                   Pure Monochrome Configuration                        "
echo "                                                                        "
echo "========================================================================"
echo ""

# === PRE-INSTALLATION CHECKS ===

print_section "Pre-Installation Checks"

# Check if running KDE Plasma
if ! command -v plasmashell &> /dev/null; then
    print_error "KDE Plasma does not appear to be installed"
    print_info "This theme requires KDE Plasma 6"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    # Get Plasma version
    PLASMA_VERSION=$(plasmashell --version 2>/dev/null | grep -oP '\d+' | head -1 || echo "unknown")
    if [[ "$PLASMA_VERSION" == "6" ]]; then
        print_success "KDE Plasma 6 detected"
    elif [[ "$PLASMA_VERSION" == "unknown" ]]; then
        print_warning "Could not determine Plasma version"
    else
        print_warning "Plasma version $PLASMA_VERSION detected (theme designed for Plasma 6)"
    fi
fi

# Check for required tools
REQUIRED_TOOLS=("plasma-apply-colorscheme" "plasma-apply-lookandfeel")
MISSING_TOOLS=()

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        MISSING_TOOLS+=("$tool")
    fi
done

if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    print_warning "Missing tools: ${MISSING_TOOLS[*]}"
    print_info "These tools are part of plasma-workspace"
    print_info "Install with: sudo pacman -S plasma-workspace"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    print_success "All required tools are installed"
fi

# Check source files exist
if [ ! -d "$PLASMA_SOURCE" ]; then
    print_error "Plasma source directory not found: $PLASMA_SOURCE"
    exit 1
fi

if [ ! -f "$PLASMA_SOURCE/$COLOR_SCHEME.colors" ]; then
    print_error "Color scheme not found: $PLASMA_SOURCE/$COLOR_SCHEME.colors"
    exit 1
fi

if [ ! -d "$PLASMA_SOURCE/achromatic" ]; then
    print_error "Global theme not found: $PLASMA_SOURCE/achromatic"
    exit 1
fi

print_success "Source files verified"

# === BACKUP EXISTING CONFIGURATIONS ===

print_section "Backing Up Existing Configurations"

mkdir -p "$BACKUP_DIR"
print_info "Backup directory: $BACKUP_DIR"

# Backup existing color scheme if present
if [ -f "$DEST_COLORS/$COLOR_SCHEME.colors" ]; then
    cp "$DEST_COLORS/$COLOR_SCHEME.colors" "$BACKUP_DIR/" 2>/dev/null || true
    print_success "Backed up existing color scheme"
fi

# Backup existing look-and-feel if present
if [ -d "$DEST_LOOKANDFEEL/$THEME_ID" ]; then
    cp -r "$DEST_LOOKANDFEEL/$THEME_ID" "$BACKUP_DIR/" 2>/dev/null || true
    print_success "Backed up existing global theme"
fi

# Backup kdeglobals
if [ -f "$HOME/.config/kdeglobals" ]; then
    cp "$HOME/.config/kdeglobals" "$BACKUP_DIR/" 2>/dev/null || true
    print_success "Backed up kdeglobals"
fi

# === INSTALLATION ===

print_section "Installing Achromatic Plasma Theme"

# Create destination directories
print_info "Creating destination directories..."
mkdir -p "$DEST_LOOKANDFEEL"
mkdir -p "$DEST_COLORS"

# Install color scheme
print_info "Installing color scheme..."
cp "$PLASMA_SOURCE/$COLOR_SCHEME.colors" "$DEST_COLORS/$COLOR_SCHEME.colors"
print_success "Installed: Color scheme ($COLOR_SCHEME)"

# Install global theme (look-and-feel)
print_info "Installing global theme..."
rm -rf "$DEST_LOOKANDFEEL/$THEME_ID" 2>/dev/null || true
cp -r "$PLASMA_SOURCE/achromatic" "$DEST_LOOKANDFEEL/$THEME_ID"
print_success "Installed: Global theme ($THEME_ID)"

# === APPLY CONFIGURATIONS ===

print_section "Applying Configurations"

# Apply color scheme
print_info "Applying color scheme..."
if command -v plasma-apply-colorscheme &> /dev/null; then
    if plasma-apply-colorscheme "$COLOR_SCHEME" 2>/dev/null; then
        print_success "Applied color scheme"
    else
        print_warning "Could not apply color scheme automatically"
        print_info "Apply manually: System Settings > Colors > Achromatic"
    fi
else
    print_warning "plasma-apply-colorscheme not found"
fi

# Apply global theme
print_info "Applying global theme..."
if command -v plasma-apply-lookandfeel &> /dev/null; then
    if plasma-apply-lookandfeel -a "$THEME_ID" 2>/dev/null; then
        print_success "Applied global theme"
    else
        print_warning "Could not apply global theme automatically"
        print_info "Apply manually: System Settings > Appearance > Global Theme > Achromatic"
    fi
else
    print_warning "plasma-apply-lookandfeel not found"
fi

# === GTK COHERENCE ===

print_section "Configuring GTK Application Coherence"

# Ensure GTK config directories exist
mkdir -p "$HOME/.config/gtk-3.0"
mkdir -p "$HOME/.config/gtk-4.0"

# Function to update or add setting in INI-style file
update_gtk_setting() {
    local file="$1"
    local key="$2"
    local value="$3"
    
    if [ ! -f "$file" ]; then
        echo "[Settings]" > "$file"
    fi
    
    if grep -q "^$key=" "$file" 2>/dev/null; then
        sed -i "s|^$key=.*|$key=$value|" "$file"
    elif grep -q "\[Settings\]" "$file" 2>/dev/null; then
        sed -i "/\[Settings\]/a $key=$value" "$file"
    else
        echo -e "[Settings]\n$key=$value" >> "$file"
    fi
}

# Configure GTK-3
GTK3_SETTINGS="$HOME/.config/gtk-3.0/settings.ini"
update_gtk_setting "$GTK3_SETTINGS" "gtk-application-prefer-dark-theme" "1"
update_gtk_setting "$GTK3_SETTINGS" "gtk-theme-name" "Breeze-Dark"
print_success "Configured GTK-3 settings"

# Configure GTK-4
GTK4_SETTINGS="$HOME/.config/gtk-4.0/settings.ini"
update_gtk_setting "$GTK4_SETTINGS" "gtk-application-prefer-dark-theme" "1"
update_gtk_setting "$GTK4_SETTINGS" "gtk-theme-name" "Breeze-Dark"
print_success "Configured GTK-4 settings"

# Set environment variables for portal integration
print_info "Configuring environment for portal integration..."

# Create or update environment.d for systemd user session
mkdir -p "$HOME/.config/environment.d"
ENV_FILE="$HOME/.config/environment.d/achromatic.conf"

cat > "$ENV_FILE" << 'EOF'
# Achromatic Theme Environment Variables
# Force dark theme for GTK applications via portal
GTK_THEME=Breeze-Dark
QT_QPA_PLATFORMTHEME=kde
EOF

print_success "Created environment configuration"

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

verify_dir() {
    local dir=$1
    local name=$2
    
    if [ -d "$dir" ]; then
        print_success "Verified: $name"
    else
        print_error "Missing: $name"
        VERIFICATION_FAILED=1
    fi
}

verify_file "$DEST_COLORS/$COLOR_SCHEME.colors" "Color scheme"
verify_dir "$DEST_LOOKANDFEEL/$THEME_ID" "Global theme"
verify_file "$DEST_LOOKANDFEEL/$THEME_ID/metadata.json" "Theme metadata"
verify_file "$DEST_LOOKANDFEEL/$THEME_ID/contents/defaults" "Theme defaults"

if [ $VERIFICATION_FAILED -eq 1 ]; then
    print_error "Verification failed - some files are missing"
    exit 1
fi

# === COMPLETION ===

print_section "Installation Complete"

echo ""
echo "========================================================================"
echo "                                                                        "
echo "            ACHROMATIC PLASMA INSTALLED SUCCESSFULLY                    "
echo "                                                                        "
echo "========================================================================"
echo ""

print_success "All Plasma configurations have been installed"
print_info "Backup location: $BACKUP_DIR"

echo ""
echo "Installed components:"
echo "  - Color Scheme: $COLOR_SCHEME"
echo "  - Global Theme: $THEME_ID"
echo "  - GTK-3/GTK-4 dark theme configuration"
echo "  - Environment variables for portal integration"
echo ""

echo "Next steps:"
echo ""
echo "  1. Log out and log back in for full effect"
echo "     OR"
echo "  2. Restart Plasma Shell: kquitapp6 plasmashell && plasmashell &"
echo ""
echo "Manual configuration (if needed):"
echo "  - System Settings > Appearance > Colors > Achromatic"
echo "  - System Settings > Appearance > Global Theme > Achromatic"
echo ""

print_info "To restore your previous configuration:"
echo "  cp -r $BACKUP_DIR/* ~/.local/share/"
echo "  cp $BACKUP_DIR/kdeglobals ~/.config/ (if backed up)"
echo ""

# === OPTIONAL: RESTART PLASMA ===

if pgrep -x "plasmashell" > /dev/null; then
    echo ""
    read -p "Restart Plasma Shell now to apply changes? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Restarting Plasma Shell..."
        kquitapp6 plasmashell 2>/dev/null || killall plasmashell 2>/dev/null || true
        sleep 2
        nohup plasmashell &>/dev/null &
        print_success "Plasma Shell restarted"
    fi
fi

echo ""
print_success "Plasma installation script completed"
echo ""

exit 0

