#!/usr/bin/env bash
# Passes the themes to the walker

THEME=$(printf "Sandy\nRandom" | walker -d)

[ -z "$THEME" ] && exit 0

~/.config/scripts/theme-switcher.sh "$THEME"
