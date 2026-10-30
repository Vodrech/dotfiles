#!/bin/sh
# Claude Code statusLine command. Saves the status JSON Claude Code sends on stdin for the
# Quickshell bar (ClaudeUsage.qml) to read, and prints a short line for Claude Code's own
# status bar.
dir="${XDG_RUNTIME_DIR:-/tmp}/claude-bar"
mkdir -p "$dir"
input=$(cat)

# Write to a temp file and rename, so the bar never reads a half-written file.
printf '%s' "$input" | jq -c --argjson now "$(date +%s)" '. + {updated_at: $now}' \
    > "$dir/status.json.tmp" && mv "$dir/status.json.tmp" "$dir/status.json"

printf '%s' "$input" | jq -r '[
    .model.display_name,
    (.context_window.used_percentage // empty | "ctx \(floor)%"),
    (.rate_limits.five_hour.used_percentage // empty | "5h \(floor)%"),
    (.rate_limits.seven_day.used_percentage // empty | "7d \(floor)%")
] | map(select(. != null)) | join(" · ")'
