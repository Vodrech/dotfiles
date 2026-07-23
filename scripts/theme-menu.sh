#!/usr/bin/env bash
# Passes the themes to the walker

THEME_DIR="$HOME/.assets/wallpapers"

THEME=$(find "$THEME_DIR" -maxdepth 1 -type f -iname "*.jpg" \
    -printf "%f\n" | sed 's/\.[Jj][Pp][Gg]$//' | walker -d)

[ -z "$THEME" ] && exit 0

~/.config/scripts/theme-switcher.sh "$THEME"

