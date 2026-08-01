#!/usr/bin/env bash

THEME=$1
WALLPAPER="$HOME/.assets/wallpapers/$THEME.jpg"

# 1. Start wallpaper animation in background
awww img "$WALLPAPER" \
    --transition-type grow \
    --transition-duration 1 &

# 2. Run matugen synchronously
matugen image "$WALLPAPER" --source-color-index 0

# Give the file system a tiny moment to ensure all config files are fully written
sleep 0.2

# 3. Kill Quickshell forcefully
pkill -9 -f quickshell

# Wait for process to fully disappear
while pgrep -f quickshell > /dev/null; do
    sleep 0.05
done

# Short breath before relaunching
sleep 0.1

# 4. Relaunch Quickshell fresh
quickshell &

# 5. Reload Hyprland
hyprctl reload

# 6. Update Walker config theme
sed -i "s/theme = .*/theme = \"$THEME\"/" ~/.config/walker/config.toml
