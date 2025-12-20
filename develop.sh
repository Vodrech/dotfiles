#
# CHECK PROGRAM ARGUMENT
# -------------------------------
if [ -z "$1" ]; then
    echo "Usage: $0 <program>"
    exit 1
fi

PROGRAM=$1
DEV_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config/$PROGRAM"

SOURCE_DIR="$DEV_DIR/$PROGRAM"
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

mkdir -p "$CONFIG_DIR"

# -------------------------------
# FUNCTION TO CREATE SYMLINK
# -------------------------------
symlink_file() {
    local file="$1"
    local rel_path="${file#$SOURCE_DIR/}"  # Relative path for nested files
    local target="$CONFIG_DIR/$rel_path"

    # Make parent directories for nested files
    mkdir -p "$(dirname "$target")"

    # Remove existing file or symlink if it exists
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -rf "$target"
    fi

    # Create symlink
    ln -s "$file" "$target"
    echo "Linked $file -> $target"
}

# -------------------------------
# INITIAL SYMLINK OF EXISTING FILES
# -------------------------------
find "$SOURCE_DIR" -type f | while read file; do
    symlink_file "$file"
done

echo "All existing files for '$PROGRAM' have been linked!"

# -------------------------------
# WATCH FOR NEW FILES OR CHANGES
# -------------------------------
if ! command -v inotifywait >/dev/null 2>&1; then
    echo "Error: inotifywait is not installed. Install inotify-tools first."
    exit 1
fi

echo "Watching '$SOURCE_DIR' for new files..."

# Watch for create and modify events
inotifywait -m -r -e create -e moved_to "$SOURCE_DIR" --format "%w%f" | while read NEW_FILE
do
    # Only handle regular files
    if [ -f "$NEW_FILE" ]; then
        symlink_file "$NEW_FILE"
    fi
done

