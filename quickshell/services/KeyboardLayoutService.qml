pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

QtObject {
    property string layout: "US"

    readonly property var names: ({
        "English (US)": "US",
        "English (Colemak)": "CMK",
        "Swedish": "SE"
    })

    property Process switchLayout: Process {
        command: ["hyprctl", "switchxkblayout", "all", "next"]
    }

    function nextLayout() {
        switchLayout.running = true
    }

    function updateLayout(eventData) {
        console.log("Keyboard event:", eventData)

        let parts = eventData.split(",")

        if (parts.length > 1) {
            let keymap = parts[1].trim()
            layout = names[keymap] ?? keymap

            console.log("Layout:", layout)
        }
    }

    property Connections hyprlandEvents: Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activelayout") {
                updateLayout(event.data)
            }
        }
    }
}
