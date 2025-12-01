#!/bin/bash
# achromatic-glitch.sh
# Surreal glitch animation for achromatic-theme
# Part of: https://github.com/[user]/achromatic-theme

# Hide cursor during animation
tput civis
trap 'tput cnorm; clear; exit' INT TERM EXIT

# Grayscale palette
W='\033[97m'    # bright white
G='\033[37m'    # light gray
D='\033[90m'    # dark gray
R='\033[0m'     # reset

# Clear screen once at start
clear

# Animation frames
frame_stable() {
    printf "\033[H"
    echo -e "${W}
   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
   ▓                       ▓
   ▓   ░░░ ▒▒▒ ▓▓▓ ███     ▓
   ▓   ░ ░ ▒ ▒ ▓ ▓ █ █     ▓
   ▓   ░░░ ▒▒▒ ▓▓▓ ███     ▓
   ▓                       ▓
   ▓   ┌┐┌ ┬ ┬ ┬   ┬       ▓
   ▓   │││ │ │ │   │       ▓
   ▓   ┘└┘ └─┘ ┴─┘ ┴─┘     ▓
   ▓                       ▓
   ▓▓▓░▒▓█████████████▓▒░▓▓▓
${R}"
}

frame_scanline_1() {
    printf "\033[H"
    echo -e "${D}
   ░░░░░░░░░░░░░░░░░░░░░░░░░
${W}   ▓                       ▓
   ▓   ░░░ ▒▒▒ ▓▓▓ ███     ▓
   ▓   ░ ░ ▒ ▒ ▓ ▓ █ █     ▓
   ▓   ░░░ ▒▒▒ ▓▓▓ ███     ▓
   ▓                       ▓
   ▓   ┌┐┌ ┬ ┬ ┬   ┬       ▓
   ▓   │││ │ │ │   │       ▓
   ▓   ┘└┘ └─┘ ┴─┘ ┴─┘     ▓
   ▓                       ▓
   ▓▓▓░▒▓█████████████▓▒░▓▓▓
${R}"
}

frame_scanline_2() {
    printf "\033[H"
    echo -e "${W}
   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
   ▓                       ▓
   ▓   ░░░ ▒▒▒ ▓▓▓ ███     ▓
${D}   ░░░░░░░░░░░░░░░░░░░░░░░░░
${W}   ▓   ░░░ ▒▒▒ ▓▓▓ ███     ▓
   ▓                       ▓
   ▓   ┌┐┌ ┬ ┬ ┬   ┬       ▓
   ▓   │││ │ │ │   │       ▓
   ▓   ┘└┘ └─┘ ┴─┘ ┴─┘     ▓
   ▓                       ▓
   ▓▓▓░▒▓█████████████▓▒░▓▓▓
${R}"
}

frame_scanline_3() {
    printf "\033[H"
    echo -e "${W}
   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
   ▓                       ▓
   ▓   ░░░ ▒▒▒ ▓▓▓ ███     ▓
   ▓   ░ ░ ▒ ▒ ▓ ▓ █ █     ▓
   ▓   ░░░ ▒▒▒ ▓▓▓ ███     ▓
   ▓                       ▓
${D}   ░░░░░░░░░░░░░░░░░░░░░░░░░
${W}   ▓   │││ │ │ │   │       ▓
   ▓   ┘└┘ └─┘ ┴─┘ ┴─┘     ▓
   ▓                       ▓
   ▓▓▓░▒▓█████████████▓▒░▓▓▓
${R}"
}

frame_shift_glitch() {
    printf "\033[H"
    echo -e "${W}
   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
   ▓                       ▓
      ░░░ ▒▒▒ ▓▓▓ ███     ▓▓
   ▓   ░ ░ ▒ ▒ ▓ ▓ █ █     ▓
   ▓   ░░░ ▒▒▒ ▓▓▓ ███     ▓
   ▓                       ▓
   ▓   ┌┐┌ ┬ ┬ ┬   ┬       ▓
 ▓   │││ │ │ │   │       ▓
   ▓   ┘└┘ └─┘ ┴─┘ ┴─┘     ▓
   ▓                       ▓
   ▓▓▓░▒▓█████████████▓▒░▓▓▓
${R}"
}

frame_corruption() {
    printf "\033[H"
    echo -e "${W}
   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
   ▓                       ▓
   ▓   ░░░ ▒▒▒ ▓▓▓ ███     ▓
   ▓   ░ ░ ▒ ▒ ▓ ▓ █ █     ▓
${G}   ▓▓▓▓█▒░▓▓▓▓▓▓▓▓▓░▒█▓▓▓▓▓▓
   ░░░░░░░░░░░░░░░░░░░░░░░░░
   ▓▓▓▓█▒░▓▓▓▓▓▓▓▓▓░▒█▓▓▓▓▓▓
${W}   ▓   │││ │ │ │   │       ▓
   ▓   ┘└┘ └─┘ ┴─┘ ┴─┘     ▓
   ▓                       ▓
   ▓▓▓░▒▓█████████████▓▒░▓▓▓
${R}"
}

frame_heavy_static() {
    printf "\033[H"
    echo -e "${G}
   ▒░▓█▒░▓▒█░▓▒░█▓▒░▓█▒░▓▒█░
   ░▓▒█░▓▒█░▒▓█░▒▓█░▒▓█▒░▓▒█
${W}   █░▓▒█░▓▒ ▒▒▒ ▓▓▓ ███ ░▓▒█
   ▒░▓█▒░ ░ ▒ ▒ ▓ ▓ █ █ ▓▒░▓
   ░▓▒█░▓▒ ▒▒▒ ▓▓▓ ███ ░█▓▒░
${G}   ▓▒░█▓▒░█▓▒░█▓▒░█▓▒░█▓▒░█▓
${W}   █░▓▒ ┌┐┌ ┬ ┬ ┬   ┬  ░▓▒█░
   ▒░▓█ │││ │ │ │   │  ▓▒░▓█
   ░▓▒█ ┘└┘ └─┘ ┴─┘ ┴─┘ ░█▓▒
${G}   ▓▒░█▓▒░█▓▒░█▓▒░█▓▒░█▓▒░█▓
   ▒░▓█▒░▓▒█░▓▒░█▓▒░▓█▒░▓▒█░
${R}"
}

frame_reforming() {
    printf "\033[H"
    echo -e "${D}
   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
   ░                       ░
   ░   ░░░ ▒▒▒ ▓▓▓ ███     ░
   ░   ░ ░ ▒ ▒ ▓ ▓ █ █     ░
   ░   ░░░ ▒▒▒ ▓▓▓ ███     ░
   ░                       ░
   ░   ┌┐┌ ┬ ┬ ┬   ┬       ░
   ░   │││ │ │ │   │       ░
   ░   ┘└┘ └─┘ ┴─┘ ┴─┘     ░
   ░                       ░
   ▓▓▓░▒▓█████████████▓▒░▓▓▓
${R}"
}

frame_inverted() {
    printf "\033[H"
    echo -e "${D}
   ░░░░░░░░░░░░░░░░░░░░░░░░░
   ░███████████████████████░
   ░███▓▓▓░▒▒▒░░░░███░░░███░
   ░███▓█▓░▒█▒░░█░███░█░███░
   ░███▓▓▓░▒▒▒░░░░███░░░███░
   ░███████████████████████░
   ░███┘└┘░┴░┴░┴░░░┴░░░░███░
   ░███│││░│░│░│░░░│░░░░███░
   ░███┌┐┌░┬─┬░┬─┬░┬─┬░░███░
   ░███████████████████████░
   ░░░▓▒░███████████████░▒▓░
${R}"
}

frame_void() {
    printf "\033[H"
    echo -e "${D}
   ░░░░░░░░░░░░░░░░░░░░░░░░░
   ░                       ░
   ░                       ░
   ░                       ░
   ░           ◯           ░
   ░                       ░
   ░                       ░
   ░                       ░
   ░                       ░
   ░                       ░
   ░░░░░░░░░░░░░░░░░░░░░░░░░
${R}"
}

# Glitch sequence patterns
glitch_burst() {
    frame_shift_glitch; sleep 0.04
    frame_corruption; sleep 0.06
    frame_heavy_static; sleep 0.08
    frame_heavy_static; sleep 0.05
    frame_corruption; sleep 0.04
    frame_reforming; sleep 0.06
}

scanline_sweep() {
    frame_scanline_1; sleep 0.03
    frame_scanline_2; sleep 0.03
    frame_scanline_3; sleep 0.03
    frame_scanline_2; sleep 0.03
    frame_scanline_1; sleep 0.03
}

void_flash() {
    frame_inverted; sleep 0.04
    frame_void; sleep 0.15
    frame_inverted; sleep 0.04
    frame_reforming; sleep 0.08
}

micro_glitch() {
    frame_shift_glitch; sleep 0.02
    frame_stable; sleep 0.02
    frame_shift_glitch; sleep 0.02
}

# Main continuous loop
while true; do
    # Stable period (random duration 1-4 seconds)
    frame_stable
    sleep $((RANDOM % 3 + 1)).$((RANDOM % 9))
    
    # Random glitch event
    case $((RANDOM % 5)) in
        0) glitch_burst ;;
        1) scanline_sweep ;;
        2) void_flash ;;
        3) micro_glitch ;;
        4) 
            # Double glitch
            glitch_burst
            sleep 0.1
            scanline_sweep
            ;;
    esac
done

