#!/usr/bin/env bash
# Passes the themes to the walker

THEME=$(printf "Red_Black\nBlue_Green" | walker -d)

[ -z "$THEME" ] && exit 0

~/.config/scripts/theme-switcher.sh "$THEME"
