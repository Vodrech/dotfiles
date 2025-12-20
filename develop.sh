# Development Script for linking configuration files from ~/.config/{program} to ~/dotfiles/{program}
# Remember to not do it with hyprland as you can launch a instance of it in another terminal with --config flag enabled | well tty also exist so it's technically possible ;)

# Check if a program name was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <program>"
    exit 1
fi

PROGRAM=$1
DEV_DIR="$HOME/dotfiles"  # Change this to your dev folder
CONFIG_DIR="$HOME/.config/$PROGRAM"

# Check if the source directory exists
SOURCE_DIR="$DEV_DIR/$PROGRAM"
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Create the target directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Loop through all files in the source directory
for file in "$SOURCE_DIR"/*; do
    filename=$(basename "$file")
    target="$CONFIG_DIR/$filename"

    # Remove existing file/symlink if it exists
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -rf "$target"
    fi

    # Create symlink
    ln -s "$file" "$target"
    echo "Linked $file -> $target"
done

echo "All files for '$PROGRAM' have been linked!"
