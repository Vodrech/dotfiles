#!/usr/bin/env bash
# Passes the themes to the walker

THEME=$(printf "catppuccin\nnord\ntokyonight\ngruvbox" | walker -d)

[ -z "$THEME" ] && exit 0

~/.config/scripts/theme-switcher.sh "$THEME"
