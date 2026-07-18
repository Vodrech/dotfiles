#!/usr/bin/env bash

case "$1" in
    toggle)
        hyprctl switchxkblayout all next
        ;;
    status)
        KEYMAP=$(hyprctl devices -j | jq -r '
            .keyboards[]
            | select(.main == true)
            | .active_keymap
        ')

        case "$KEYMAP" in
            *Colemak*)
                echo " CMK"
                ;;
            *Swedish*)
                echo " SWE"
                ;;
            *)
                echo " US"
                ;;
        esac
        ;;
esac
