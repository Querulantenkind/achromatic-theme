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

### i3 (Abyss Theme)

A complete X11 window manager setup with matching components:

- **Window Manager**: i3 with matching keybindings
- **Status Bar**: i3status with text-only modules
- **Application Launcher**: Rofi (same theme as Hyprland)
- **Notifications**: Dunst with three urgency levels
- **Terminal**: Optimized for Kitty (compatible with any terminal)

### ZSH Prompt

A feature-rich ZSH configuration optimized for file navigation:

- **Custom Prompt**: Two-line monochrome prompt with git integration
- **Smart Navigation**: zoxide for intelligent directory jumping
- **Fuzzy Finding**: fzf integration for files, history, and completions
- **Modern Tools**: eza, fd, bat, ripgrep aliases
- **Syntax Highlighting**: Yellow accents for commands and suggestions
- **Fastfetch Greeting**: System info display on shell startup

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

### Mako Notifications (Hyprland)

- **Three Urgency Levels**: Low (dimmed), Normal, Critical (persistent)
- **Smart Timeouts**: Auto-dismiss for normal, manual for critical
- **Minimal Design**: No icons, clean typography
- **Overlay Layer**: Always visible when needed

### i3 Configuration

- **Pure Monochrome**: Matching colors with Hyprland setup
- **VIM-Style Navigation**: h/j/k/l for window focus
- **i3-gaps Support**: Inner gaps 5px, outer gaps 10px
- **Smart Workspace Management**: 9 workspaces with scratchpad
- **Matching Keybindings**: Same shortcuts as Hyprland where possible

### i3status Bar

- **Text-Only Format**: CPU, RAM, Network, Battery, Volume, Clock
- **Monochrome States**: Good, degraded, bad states in grayscale
- **Minimal Design**: No icons, clean monospace font

### Dunst Notifications (i3)

- **Three Urgency Levels**: Matching Mako configuration
- **Smart Timeouts**: Auto-dismiss for normal, manual for critical
- **Minimal Design**: No icons, monospace typography
- **Matching Colors**: Same palette as all other components

### ZSH Prompt Features

- **Two-Line Layout**: Clean separation between info and input
- **Smart Path Shortening**: `~/Documents/projects/achromatic` becomes `~/D/p/achromatic`
- **Git Integration**: Branch name with status symbols (`*` modified, `+` staged, `?` untracked, `>` ahead, `<` behind, `$` stash)
- **Execution Time**: Shows duration for commands taking longer than 3 seconds
- **Exit Code Indicator**: Visual feedback on command failure
- **Context Indicators**: SSH, root, read-only directory, virtualenv, background jobs

### ZSH Navigation Tools

- **zoxide**: Smart `cd` that learns your most-used directories
- **fzf**: Fuzzy finder for files, directories, and history
- **eza**: Modern `ls` replacement with git integration
- **fd**: Fast and user-friendly `find` alternative
- **bat**: `cat` with syntax highlighting
- **ripgrep**: Lightning-fast recursive search
- **yazi**: Terminal file manager with directory sync

### ZSH Plugins

- **zsh-autosuggestions**: Fish-like command suggestions (gold color)
- **zsh-syntax-highlighting**: Real-time syntax highlighting (yellow for commands)
- **zsh-history-substring-search**: Fish-like history navigation
- **fzf-tab**: Replace completion menu with fzf

### Fastfetch Integration

- **System Greeting**: Displays system info on every new shell
- **Achromatic Theme**: Monochrome fastfetch configuration
- **Glitch Animation**: Optional screensaver-style animation (`achromatic-glitch`)

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

Accent Colors (ZSH):
#d4a017  - Muted Gold (autosuggestions, aliases)
#f6d600  - Bright Yellow (valid commands, history matches)
```

## Requirements

### Base System

- Arch Linux (or similar rolling release)
- For Hyprland: Hyprland (>= 0.40.0), Wayland session
- For i3: i3-wm or i3-gaps, X11 session

### Required Packages (Hyprland)
```bash
sudo pacman -S hyprland waybar rofi mako kitty \
               polkit-kde-agent networkmanager \
               network-manager-applet pavucontrol \
               wl-clipboard cliphist grim slurp \
               brightnessctl playerctl
```

### Required Packages (i3)
```bash
sudo pacman -S i3-wm i3status rofi dunst kitty \
               polkit-gnome networkmanager \
               network-manager-applet pavucontrol \
               scrot brightnessctl playerctl
```

### Required Packages (ZSH)
```bash
# Core tools
sudo pacman -S zsh zoxide fzf eza fd bat ripgrep yazi fastfetch

# ZSH plugins
sudo pacman -S zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search

# fzf-tab (from AUR)
yay -S fzf-tab-git
```

### Optional Packages
```bash
sudo pacman -S micro chromium
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
3. **KDE Plasma** - Plasma 6 color scheme
4. **Hyprland + i3** - Install both tiling WM configurations
5. **Fastfetch** - Glitch animation and system fetch
6. **ZSH** - Shell prompt with navigation tools

You can also run the individual installers directly:

```bash
# Install only Hyprland configuration
./install-hyprland.sh

# Install only i3 configuration
./install-i3.sh

# Install only ZSH configuration
./install-zsh.sh
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

### ZSH Key Bindings

| Key Combination | Action |
|----------------|--------|
| `Ctrl + T` | Fuzzy file search |
| `Ctrl + R` | Fuzzy history search |
| `Alt + C` | Fuzzy cd into directory |
| `Tab` | Smart completion (fzf-tab) |
| `Up/Down` | History substring search |
| `Ctrl + Right/Left` | Move word forward/backward |

### ZSH Commands & Aliases

| Command | Action |
|---------|--------|
| `cd <partial>` | Smart jump with zoxide |
| `y` | Open yazi file manager (cd on exit) |
| `fcd` | Fuzzy cd into any subdirectory |
| `fe` | Fuzzy open file in editor |
| `fz` | Fuzzy zoxide directory selection |
| `fgl` | Fuzzy git log browser |
| `l` / `ll` / `la` | Enhanced ls with eza |
| `lt` | Tree view (2 levels) |
| `lS` / `lm` | Sort by size / modified time |
| `..` / `...` / `....` | Go up 1/2/3 directories |
| `take <dir>` | Create directory and cd into it |
| `bd <name>` | Jump back to parent directory matching name |
| `gs` / `gd` / `ga` | Git status / diff / add |
| `reload` | Reload ZSH configuration |

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
│   │   └── config
│   ├── i3status/
│   │   └── config
│   ├── rofi/
│   │   ├── config.rasi
│   │   └── abyss.rasi
│   └── dunst/
│       └── dunstrc
├── zsh/
│   ├── .zshrc              # Main ZSH configuration
│   ├── prompt.zsh          # Custom monochrome prompt
│   ├── navigation.zsh      # zoxide, fzf, aliases
│   ├── completion.zsh      # Completion system
│   └── history.zsh         # History configuration
├── fastfetch/
│   ├── config.jsonc        # Fastfetch configuration
│   ├── logo.txt            # ASCII logo
│   └── achromatic-glitch.sh # Glitch animation script
├── plasma/
│   ├── achromatic/         # Plasma theme
│   └── Achromatic.colors   # Color scheme
├── sddm/
│   └── achromatic/         # SDDM login theme
├── screenshots/
│   ├── hyprland/
│   └── i3/
├── install.sh              # Master installer with menu
├── install-hyprland.sh     # Hyprland-specific installer
├── install-i3.sh           # i3-specific installer
├── install-zsh.sh          # ZSH prompt installer
├── install-plasma.sh       # Plasma theme installer
├── install-fastfetch.sh    # Fastfetch installer
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

### ZSH not loading theme
```bash
# Verify files are installed
ls ~/.config/achromatic-zsh/

# Reload configuration
source ~/.zshrc
```

### ZSH plugins not working
```bash
# Check if plugins are installed
ls /usr/share/zsh/plugins/

# Install missing plugins
sudo pacman -S zsh-autosuggestions zsh-syntax-highlighting
```

### Fastfetch not showing
```bash
# Test fastfetch directly
fastfetch

# Check if installed
which fastfetch
```

## Roadmap

- [x] Automated installation script
- [x] i3 window manager support
- [x] KDE Plasma theme integration
- [x] ZSH prompt configuration
- [x] Fastfetch integration
- [x] SDDM login theme
- [ ] Kitty terminal color scheme
- [ ] Hyprlock screen locker theme
- [ ] Hyprpaper wallpaper integration
- [ ] GTK/Qt theme integration
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