current=$(hyprctl getoption input:kb_layout | awk '/str:/ {print $2}')

if [ "$1" = "toggle" ]; then
    if [ "$current" = "us" ]; then
        hyprctl keyword input:kb_layout colemak
        current="colemak"
    else
        hyprctl keyword input:kb_layout us
        current="us"
    fi
fi

# Output for Waybar
echo "$current"

