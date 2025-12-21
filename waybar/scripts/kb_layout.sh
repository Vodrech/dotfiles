# File: kb_layout.sh
# Toggle US <-> FR layout for Hyprland via hyprctl

current=$(hyprctl getoption input:kb_layout)

if [ "$1" == "toggle" ]; then
  if [ "$current" == "us" ]; then
    hyprctl keyword input:kb_layout colemak
  else
    hyprctl keyword input:kb_layout us
  fi
fi

# Output the current layout for Waybar
echo "$current"
