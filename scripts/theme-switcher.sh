#!/usr/bin/env bash

THEME=$1

WALLPAPER="$HOME/.assets/wallpapers/$THEME.jpg"

# Change wallpaper
awww img "$WALLPAPER" \
    --transition-type grow \
    --transition-duration 1

# Generate colors
matugen image "$WALLPAPER" \
	  --source-color-index 0

# Reload Hyprland
hyprctl reload

# Reload Waybar
pkill waybar
waybar &

# Reload Walker theme
sed -i "s/theme = .*/theme = \"$THEME\"/" \
    ~/.config/walker/config.toml
