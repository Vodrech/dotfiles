# PREREQUISITE: jq
current=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main==true) | .active_keymap' | xargs)
# echo "Debug: kb_layout script output: $current" | systemd-cat -t waybar-kb # Logging to journalctl enable if wrong
layout="err"

if [[ "$current" == "English (US)" ]]; then
	layout="us"
elif [[ "$current" == "English (Colemak)" ]]; then
	layout="cole"
elif [[ $current == *Swedish* ]]; then
	layout="se"
else
	layout="??"
fi

# Output for Waybar
echo "$layout"
