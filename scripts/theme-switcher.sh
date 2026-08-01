#!/usr/bin/env bash

THEME=$1
WALLPAPER="$HOME/.assets/wallpapers/$THEME.jpg"

# 1. Start wallpaper animation in background (non-blocking)
awww img "$WALLPAPER" \
    --transition-type grow \
    --transition-duration 1 &

# 2. Run matugen synchronously (WAIT until all color files are saved to disk)
matugen image "$WALLPAPER" --source-color-index 0

# 3. Safely kill Quickshell and WAIT for process to fully terminate
if pgrep -x quickshell > /dev/null; then
    pkill -x quickshell
    while pgrep -x quickshell > /dev/null; do 
        sleep 0.05 
    done
fi

# 4. Relaunch Quickshell with new colors loaded
quickshell &

# 5. Reload Hyprland
hyprctl reload

# 6. Update Walker theme
sed -i "s/theme = .*/theme = \"$THEME\"/" ~/.config/walker/config.toml
