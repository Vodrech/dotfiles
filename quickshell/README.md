# quickshell-bar

A floating "islands" bar for Hyprland, built with Quickshell (0.3+), with a Catppuccin Mocha theme.

| Island | Contents |
|---|---|
| Left | NixOS logo (click for favourite apps), open windows menu (click a window to focus it, × to close it), workspaces (click to switch, scroll to cycle), active window title |
| Center | Clock and date (click for a calendar with appointments) |
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
