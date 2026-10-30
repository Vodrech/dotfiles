pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// All appointment storage goes through this singleton. It is a local JSON file for now;
// moving to a synced calendar (CalDAV / .ics) later only means replacing the storage
// here, as long as eventsOn / hasEvents / add / remove keep working.
//
// Each event: { uid, date: "yyyy-MM-dd", time: "HH:mm" or "" (all day), title }
Singleton {
    id: root

    readonly property var events: adapter.events

    function key(date: date): string {
        return Qt.formatDate(date, "yyyy-MM-dd");
    }

    // Events on one day, all-day first, then by time.
    function eventsOn(dateKey: string): var {
        return events.filter(e => e.date === dateKey).sort((a, b) => a.time.localeCompare(b.time));
    }

    function hasEvents(dateKey: string): bool {
        return events.some(e => e.date === dateKey);
    }

    // Accepts "", "9", "930", "9:30", "09.30". Returns "HH:mm", "" for all day, or null if invalid.
    function parseTime(text: string): var {
        const t = text.trim();
        if (t === "")
            return "";
        const m = t.match(/^(\d{1,2})(?:[:.]?(\d{2}))?$/);
        if (!m)
            return null;
        const h = parseInt(m[1]), min = parseInt(m[2] ?? "0");
        if (h > 23 || min > 59)
            return null;
        return String(h).padStart(2, "0") + ":" + String(min).padStart(2, "0");
    }

    function add(dateKey: string, time: string, title: string) {
        const uid = Date.now().toString(36) + "-" + Math.random().toString(36).slice(2, 8);
        adapter.events = [...events, { uid, date: dateKey, time, title }];
        file.writeAdapter();
    }

    function remove(uid: string) {
        adapter.events = events.filter(e => e.uid !== uid);
        file.writeAdapter();
    }

    FileView {
        id: file
        // Outside the shell folder, so the bar files can be replaced or shared without it.
        path: (Quickshell.env("XDG_DATA_HOME") || Quickshell.env("HOME") + "/.local/share") + "/quickshell-bar/appointments.json"
        watchChanges: true                 // pick up hand edits to the file
        onFileChanged: reload()
        onLoadFailed: error => {
            if (error === FileViewError.FileNotFound)
                writeAdapter();
        }

        JsonAdapter {
            id: adapter
            property var events: []
        }
    }
}
