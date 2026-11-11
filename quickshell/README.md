# quickshell-bar

A compact, full-width bar for Hyprland, built with Quickshell (0.3+), with a Catppuccin Mocha theme.

| Section | Contents |
|---|---|
| Left | NixOS logo (click for favourite apps), games (click to launch a Lutris game), open windows menu (click a window to focus it, × to close it), workspaces (click to switch, scroll to cycle), active window title |
| Center | Text file preview (click to open; sits just left of the clock), clock and date (click for a calendar with appointments) |
| Right | System tray, Claude Code usage (click for details), CPU and RAM, network (click to open nm-connection-editor), keyboard layout (click to pick a layout, scroll to cycle), volume (scroll to change, left-click to pick the default output and input device and set each app's volume, middle-click to mute, right-click to open pavucontrol) |

## Run

Put the files in `~/.config/quickshell`, Quickshell's default config folder, then run:

    quickshell

To start it with Hyprland, add this to hyprland.conf (or `exec-once` in home-manager):

    exec-once = quickshell

Quickshell reloads saved changes automatically while it's running.

## Appointments

Click a day in the calendar, type a time (`14:30`, `1430` or `9`; leave it empty for all day) and a title, then press Enter. Days with appointments show a dot. Appointments are saved in `~/.local/share/quickshell-bar/appointments.json` (or under `$XDG_DATA_HOME` if set), outside the bar folder so it can be shared or replaced without them. You can also edit the file by hand; the bar picks up changes automatically.

All storage goes through `Appointments.qml`, so switching to a synced calendar later only means changing that file.

## Favourite apps

Edit the `favorites` list at the top of `Launcher.qml`. Use desktop entry ids, which are the `.desktop` file names without the extension. To see them:

    ls /run/current-system/sw/share/applications ~/.nix-profile/share/applications /etc/profiles/per-user/$USER/share/applications

## Games

The gamepad icon lists your installed Lutris games, most recently played first, with playtime and runner. The folder chips at the top filter by Lutris category (right-click a game in Lutris > Categories to add it to one); games you hide in Lutris are left out. Categories are read from Lutris's database (`~/.local/share/lutris/pga.db`, read-only) with `python3`, since Lutris has no command for them. Type to filter, use Up/Down to pick a game, and press Enter or click to launch it (`lutris lutris:rungameid/<id>`). The list is reloaded from `lutris --list-games --installed --json` each time you open it, so new installs show up without restarting the bar. Icons come from Lutris's own game icons, banners or cover art; games with none of these show their first letter.

## Text file preview

Click the file icon to browse your folders, starting at your home folder. The browser lists folders and `.md` / `.txt` files (hidden ones are left out; change `nameFilters` in `TextPreview.qml` for other types); click a folder to open it, the arrow to go up, or the house to go home. You can also type a path to a file or folder and press Enter. Select text and press Ctrl+C, click a line number to copy that line, or use Copy selection / Copy all. Ctrl+F (or the Find field, Enter for the next match) searches, Ctrl+L jumps to the path field, Shift+scroll scrolls sideways, and the icon next to the path opens the file in its default app. The preview updates when the file changes. Recently opened files show as chips and are remembered in `~/.local/share/quickshell-bar/text-preview.json`; to always show some files, add them to `pinned` at the top of `TextPreview.qml`.

## Claude Code usage

On Pro/Max plans the bar shows the 5-hour and weekly limits as `5h|weekly` percentages plus a bar for the 5-hour limit; click it for details, including the context usage of your latest Claude Code session. It reads what `claude-statusline.sh` saves each time Claude Code updates its status line. To hook it up, add this to `~/.claude/settings.json`:

    "statusLine": {
      "type": "command",
      "command": "~/.config/quickshell/claude-statusline.sh"
    }

The module stays hidden until the first update arrives, and dims after 10 minutes without one.

## Customise

- Colours, font, sizes and spacing are in `Theme.qml`
- Glyphs are in `Icons.qml` (Nerd Font v3 code points)
- Module layout is in `Bar.qml`
- `Dropdown.qml` is the shared panel behind the calendar, windows menu and audio device picker; use it for new dropdowns
