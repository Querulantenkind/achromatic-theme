#!/bin/bash

# ============================================================================
# ACHROMATIC FASTFETCH INSTALLATION SCRIPT
# Installs glitch animation and fastfetch configuration
# ============================================================================

set -e

# === COLOR DEFINITIONS ===

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# === VARIABLES ===

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FASTFETCH_DIR="$HOME/.config/fastfetch"

# === BANNER ===

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║              ACHROMATIC FASTFETCH INSTALLER               ║"
echo "║            Glitch Animation & System Fetch                ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# === CHECK FOR FASTFETCH ===

if ! command -v fastfetch &> /dev/null; then
    print_warning "fastfetch is not installed"
    print_info "The glitch animation will work, but fastfetch config won't be used"
    echo ""
fi

# === BACKUP EXISTING CONFIG ===

if [ -d "$FASTFETCH_DIR" ]; then
    print_info "Backing up existing fastfetch configuration..."
    BACKUP_DIR="$HOME/.config/fastfetch.backup.$(date +%Y%m%d_%H%M%S)"
    cp -r "$FASTFETCH_DIR" "$BACKUP_DIR"
    print_success "Backup created at: $BACKUP_DIR"
fi

# === CREATE DIRECTORIES ===

print_info "Creating fastfetch config directory..."
mkdir -p "$FASTFETCH_DIR"

# === COPY FILES ===

print_info "Installing achromatic fastfetch configuration..."

# Copy config
cp "$SCRIPT_DIR/fastfetch/config.jsonc" "$FASTFETCH_DIR/"
print_success "Installed: config.jsonc"

# Copy logo
cp "$SCRIPT_DIR/fastfetch/logo.txt" "$FASTFETCH_DIR/"
print_success "Installed: logo.txt"

# Copy glitch animation script
cp "$SCRIPT_DIR/fastfetch/achromatic-glitch.sh" "$FASTFETCH_DIR/"
chmod +x "$FASTFETCH_DIR/achromatic-glitch.sh"
print_success "Installed: achromatic-glitch.sh"

# === CREATE CONVENIENCE SYMLINK ===

print_info "Creating convenience symlink in ~/.local/bin..."
mkdir -p "$HOME/.local/bin"

# Create wrapper script
cat > "$HOME/.local/bin/achromatic-glitch" << 'EOF'
#!/bin/bash
# Achromatic glitch animation launcher
exec "$HOME/.config/fastfetch/achromatic-glitch.sh" "$@"
EOF
chmod +x "$HOME/.local/bin/achromatic-glitch"
print_success "Created: ~/.local/bin/achromatic-glitch"

# === FINAL MESSAGES ===

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║          FASTFETCH CONFIGURATION INSTALLED                ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "Usage:"
echo ""
echo "  Run the glitch animation:"
echo "    achromatic-glitch"
echo ""
echo "  Or directly:"
echo "    ~/.config/fastfetch/achromatic-glitch.sh"
echo ""
echo "  Run fastfetch with achromatic theme:"
echo "    fastfetch"
echo ""
echo "  Press Ctrl+C to stop the animation"
echo ""

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    print_warning "~/.local/bin is not in your PATH"
    print_info "Add this to your ~/.zshrc or ~/.bashrc:"
    echo '    export PATH="$HOME/.local/bin:$PATH"'
    echo ""
fi

print_success "Installation complete!"

