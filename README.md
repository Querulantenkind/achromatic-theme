# Achromatic

A collection of pure monochrome desktop environment configurations for Linux. Achromatic embraces a **Terminal Purist** philosophy: minimalism, performance over decoration, and strictly grayscale aesthetics.

## Philosophy

- **Performance First**: Functionality and speed take precedence over visual effects
- **Monochrome Only**: Strictly grayscale palette (#0a0a0a to #ffffff)
- **No Icons**: Text-based interface elements throughout
- **Semantic Monochrome**: Even errors, warnings, and success states use grayscale
- **Terminal-Centric**: Built for keyboard-driven workflow

## Available Configurations

### Hyprland (Abyss Theme)

A complete Wayland compositor setup with matching components:

- **Window Manager**: Hyprland with OmarchyOS-inspired keybindings
- **Status Bar**: Waybar with system monitoring
- **Application Launcher**: Rofi in dmenu mode
- **Notifications**: Mako with three urgency levels
- **Terminal**: Optimized for Kitty (compatible with any terminal)

## Screenshots

*Screenshots will be added soon*

## Features

### Hyprland Configuration

- **Pure Monochrome**: Everything from window borders to notifications
- **VIM-Style Navigation**: h/j/k/l for window focus
- **Performance Optimized**: Minimal animations, disabled blur effects
- **Smart Workspace Management**: 9 workspaces with silent move support
- **Scratchpad Support**: Quick access to floating workspace
- **OmarchyOS Keybindings**: Intuitive, consistent key layout

### Waybar Components

- **System Monitoring**: CPU and RAM usage
- **Network Status**: WiFi/Ethernet with ESSID display
- **Battery Indicator**: Charging states with critical warnings
- **Audio Control**: Volume display with mute indicator
- **System Tray**: Minimalist icon integration
- **Clock**: 24-hour format with date tooltip

### Rofi Launcher

- **No Icons Mode**: Pure text interface
- **Alternating Rows**: Visual separation without color
- **Bold Selection**: Clear indication of focused item
- **Grayscale States**: Normal, active, urgent differentiation

### Mako Notifications

- **Three Urgency Levels**: Low (dimmed), Normal, Critical (persistent)
- **Smart Timeouts**: Auto-dismiss for normal, manual for critical
- **Minimal Design**: No icons, clean typography
- **Overlay Layer**: Always visible when needed

## Color Palette
```
#0a0a0a  - Deepest Black (backgrounds)
#111111  - Very Dark Gray (modules)
#1a1a1a  - Dark Gray (hover, active)
#2a2a2a  - Medium Gray (borders, highlights)
#3a3a3a  - Light Gray (critical states)
#666666  - Dimmed Gray (inactive)
#cccccc  - Light Gray (standard text)
#e0e0e0  - Very Light Gray (important text)
#ffffff  - Pure White (maximum emphasis)
```

## Requirements

### Base System

- Arch Linux (or similar rolling release)
- Hyprland (>= 0.40.0)
- Wayland session

### Required Packages
```bash
sudo pacman -S hyprland waybar rofi mako kitty \
               polkit-kde-agent networkmanager \
               network-manager-applet pavucontrol \
               wl-clipboard cliphist grim slurp \
               brightnessctl playerctl
```

### Optional Packages
```bash
sudo pacman -S yazi micro chromium
```

## Installation

### Manual Installation

1. **Clone the repository**:
```bash
git clone https://github.com/yourusername/achromatic.git
cd achromatic
```

2. **Backup existing configurations**:
```bash
mkdir -p ~/.config/backup
cp -r ~/.config/hypr ~/.config/backup/ 2>/dev/null || true
cp -r ~/.config/waybar ~/.config/backup/ 2>/dev/null || true
cp -r ~/.config/rofi ~/.config/backup/ 2>/dev/null || true
cp -r ~/.config/mako ~/.config/backup/ 2>/dev/null || true
```

3. **Copy configurations**:
```bash
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar
mkdir -p ~/.config/rofi
mkdir -p ~/.config/mako

cp hyprland/config/hyprland.conf ~/.config/hypr/hyprland.conf
cp hyprland/waybar/config ~/.config/waybar/config
cp hyprland/waybar/style.css ~/.config/waybar/style.css
cp hyprland/rofi/config.rasi ~/.config/rofi/config.rasi
cp hyprland/rofi/abyss.rasi ~/.config/rofi/abyss.rasi
cp hyprland/mako/config ~/.config/mako/config
```

4. **Restart Hyprland** or reload configuration:
```bash
hyprctl reload
```

### Automated Installation

Run the master installer script which provides a menu to choose your configuration:

```bash
./install.sh
```

The installer will prompt you to select:
1. **Hyprland** - Wayland compositor with Waybar, Rofi, and Mako
2. **i3** - X11 window manager with i3status, Rofi, and Dunst
3. **Both** - Install configurations for both environments

You can also run the individual installers directly:

```bash
# Install only Hyprland configuration
./install-hyprland.sh

# Install only i3 configuration
./install-i3.sh
```

The installer will:
- Check for required dependencies
- Backup existing configurations
- Install the Achromatic theme files
- Verify the installation

## Key Bindings

### System

| Key Combination | Action |
|----------------|--------|
| `Super + Shift + Q` | Close active window |
| `Super + Shift + Alt + Q` | Exit Hyprland |
| `Super + Shift + R` | Reload Hyprland config |
| `Super + F` | Fullscreen toggle |
| `Super + Shift + F` | Floating toggle |

### Applications

| Key Combination | Action |
|----------------|--------|
| `Super + Return` | Launch terminal (Kitty) |
| `Super + Space` | Application launcher (Rofi) |
| `Super + E` | Text editor (Micro) |
| `Super + Y` | File manager (Yazi) |
| `Super + Shift + B` | Browser (Chromium) |

### Window Navigation (VIM-style)

| Key Combination | Action |
|----------------|--------|
| `Super + H/J/K/L` | Focus left/down/up/right |
| `Super + Shift + H/J/K/L` | Move window left/down/up/right |
| `Super + Ctrl + H/J/K/L` | Resize window left/down/up/right |

### Workspaces

| Key Combination | Action |
|----------------|--------|
| `Super + 1-9` | Switch to workspace 1-9 |
| `Super + Shift + 1-9` | Move window to workspace 1-9 |
| `Super + Ctrl + Shift + 1-9` | Move window silently to workspace 1-9 |
| `Super + Tab` | Next workspace |
| `Super + Shift + Tab` | Previous workspace |

### Scratchpad

| Key Combination | Action |
|----------------|--------|
| `Super + S` | Toggle scratchpad |
| `Super + Shift + S` | Move window to scratchpad |

### Media & System

| Key Combination | Action |
|----------------|--------|
| `Print` | Screenshot (full screen) |
| `Shift + Print` | Screenshot (selection) |
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Toggle mute |
| `XF86MonBrightnessUp` | Brightness up |
| `XF86MonBrightnessDown` | Brightness down |

## Project Structure
```
achromatic/
├── hyprland/
│   ├── config/
│   │   └── hyprland.conf
│   ├── waybar/
│   │   ├── config
│   │   └── style.css
│   ├── rofi/
│   │   ├── config.rasi
│   │   └── abyss.rasi
│   └── mako/
│       └── config
├── i3/
│   ├── config/
│   ├── i3status/
│   ├── rofi/
│   └── dunst/
├── screenshots/
│   ├── hyprland/
│   └── i3/
├── install.sh           # Master installer with menu
├── install-hyprland.sh  # Hyprland-specific installer
├── install-i3.sh        # i3-specific installer
└── README.md
```

## Configuration Details

### Waybar Modules

The status bar displays the following information:

- **Left**: CPU usage, RAM usage
- **Center**: Current time (click for date)
- **Right**: Network status, Battery level, Volume, System tray

### Rofi Behavior

- **Width**: 40% of screen
- **Lines**: 10 visible entries
- **Selection**: Bold white text on medium gray background
- **No Icons**: Pure text mode for Terminal Purist philosophy

### Mako Urgency Levels

- **Low**: Dimmed text, 3-second timeout, minimal background
- **Normal**: Standard text, 5-second timeout, default background
- **Critical**: Bright text, permanent display (manual dismiss), highlighted background

## Customization

### Changing Colors

All colors are consistently defined in each configuration file:

- **Hyprland**: `hyprland.conf` (border colors)
- **Waybar**: `waybar/style.css` (all color definitions)
- **Rofi**: `rofi/abyss.rasi` (color variables at top)
- **Mako**: `mako/config` (urgency sections)

### Modifying Keybindings

Edit `hyprland.conf` and search for the keybinding section. All bindings follow this format:
```conf
bind = $mainMod, KEY, action, parameters
```

### Adding Waybar Modules

Edit `waybar/config` to add modules from the [Waybar wiki](https://github.com/Alexays/Waybar/wiki/Module:-Custom), then style them in `waybar/style.css`.

## Troubleshooting

### Waybar not showing
```bash
killall waybar
waybar &
```

### Rofi theme not loading
```bash
rofi -show drun -theme ~/.config/rofi/abyss.rasi
```

### Mako notifications not appearing
```bash
killall mako
mako &
notify-send "Test" "This is a test notification"
```

### Check Hyprland logs
```bash
cat /tmp/hypr/$(ls -t /tmp/hypr/ | head -n 1)/hyprland.log
```

## Roadmap

- [x] Automated installation script
- [ ] i3 window manager support (structure ready, configs coming soon)
- [ ] KDE Plasma theme integration
- [ ] Kitty terminal color scheme
- [ ] Hyprlock screen locker theme
- [ ] Hyprpaper wallpaper integration
- [ ] CI/CD with GitHub Actions

## Contributing

Contributions are welcome. Please follow these guidelines:

1. Maintain the monochrome color palette
2. Keep configurations minimal and performance-focused
3. Test on a clean Arch Linux installation
4. Update documentation for any changes
5. Follow the Terminal Purist philosophy

## License

MIT License - See LICENSE file for details

## Acknowledgments

- [Hyprland](https://hyprland.org/) - Dynamic tiling Wayland compositor
- [Waybar](https://github.com/Alexays/Waybar) - Highly customizable status bar
- [Rofi](https://github.com/davatorium/rofi) - Window switcher and application launcher
- [Mako](https://github.com/emersion/mako) - Lightweight Wayland notification daemon
- [OmarchyOS](https://github.com/omarchy) - Keybinding inspiration

## Support

For issues, questions, or suggestions, please open an issue on GitHub.

---

**Note**: This is a personal configuration project. Use at your own risk and always backup your existing configurations before applying these settings.