#!/bin/bash

# ============================================================================
# ACHROMATIC MASTER INSTALLATION SCRIPT
# Installation menu for monochrome desktop configurations
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

# === CHECK IF RUNNING AS ROOT ===

if [[ $EUID -eq 0 ]]; then
   print_error "This script should NOT be run as root"
   print_info "Please run as your regular user"
   exit 1
fi

# === VARIABLES ===

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# === BANNER ===

show_banner() {
    clear
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║                    ACHROMATIC INSTALLER                   ║"
    echo "║                Pure Monochrome Configuration              ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
}

# === MENU ===

show_menu() {
    echo "Select what you want to install:"
    echo ""
    echo "  1) Install Hyprland configuration (Wayland)"
    echo "  2) Install i3 configuration (X11)"
    echo "  3) Install KDE Plasma 6 theme"
    echo "  4) Install Hyprland + i3 (tiling WMs)"
    echo "  5) Exit"
    echo ""
}

# === INSTALLATION FUNCTIONS ===

install_hyprland() {
    if [ -f "$SCRIPT_DIR/install-hyprland.sh" ]; then
        bash "$SCRIPT_DIR/install-hyprland.sh"
    else
        print_error "install-hyprland.sh not found"
        exit 1
    fi
}

install_i3() {
    if [ -f "$SCRIPT_DIR/install-i3.sh" ]; then
        bash "$SCRIPT_DIR/install-i3.sh"
    else
        print_error "install-i3.sh not found"
        exit 1
    fi
}

install_plasma() {
    if [ -f "$SCRIPT_DIR/install-plasma.sh" ]; then
        bash "$SCRIPT_DIR/install-plasma.sh"
    else
        print_error "install-plasma.sh not found"
        exit 1
    fi
}

install_tiling() {
    print_info "Installing both Hyprland and i3 configurations..."
    echo ""
    
    # Install Hyprland first
    install_hyprland
    
    echo ""
    echo "─────────────────────────────────────────────────────────────"
    echo ""
    
    # Then install i3
    install_i3
    
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║           BOTH CONFIGURATIONS INSTALLED SUCCESSFULLY      ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
}

# === MAIN ===

show_banner
show_menu

read -p "Enter your choice [1-5]: " choice

case $choice in
    1)
        install_hyprland
        ;;
    2)
        install_i3
        ;;
    3)
        install_plasma
        ;;
    4)
        install_tiling
        ;;
    5)
        print_info "Installation cancelled"
        exit 0
        ;;
    *)
        print_error "Invalid option: $choice"
        print_info "Please run the script again and select 1-5"
        exit 1
        ;;
esac

exit 0
