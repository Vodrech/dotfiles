#!/usr/bin/env bash

THEME=$1
WALLPAPER="$HOME/.assets/wallpapers/$THEME.jpg"

# 1. Start wallpaper animation in background
awww img "$WALLPAPER" \
    --transition-type grow \
    --transition-duration 1 &

# 2. Run matugen synchronously so files are fully written first
matugen image "$WALLPAPER" --source-color-index 0

# 3. Forcefully kill any running quickshell instance and wait for it to drop
pkill -9 -f quickshell
while pgrep -f quickshell > /dev/null; do
    sleep 0.05
done

# 4. Relaunch Quickshell fresh
quickshell &

# 5. Reload Hyprland
hyprctl reload

# 6. Update Walker config theme
sed -i "s/theme = .*/theme = \"$THEME\"/" ~/.config/walker/config.toml
