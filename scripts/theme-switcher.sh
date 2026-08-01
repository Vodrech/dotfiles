#!/usr/bin/env bash

THEME=$1
WALLPAPER="$HOME/.assets/wallpapers/$THEME.jpg"

# 1. Start the wallpaper transition (takes 1 second)
awww img "$WALLPAPER" \
    --transition-type grow \
    --transition-duration 1 &

# 2. Run matugen and reloads concurrently in the background 
# so they don't block the UI thread during the animation
(
    matugen image "$WALLPAPER" --source-color-index 0
    hyprctl reload
    pkill quickshell
    quickshell &
    sed -i "s/theme = .*/theme = \"$THEME\"/" ~/.config/walker/config.toml
) &

# Wait for all background tasks to cleanly wrap up
wait
