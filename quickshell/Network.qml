import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

// Network status via nmcli, polled every 5 seconds. Click opens nm-connection-editor.
RowLayout {
    id: root
    spacing: 6

    property string type: ""        // "ethernet", "wifi" or "" when offline
    property string connection: ""
    property int signal: 0          // wifi strength, 0..100

    function parse(out: string) {
        const [devices, wifi] = out.split("---");
        let found = null;
        for (const line of devices.trim().split("\n")) {
            const [t, state, ...name] = line.split(":");
            if ((t === "ethernet" || t === "wifi") && state === "connected") {
                found = { type: t, name: name.join(":").replace(/\\/g, "") };
                if (t === "ethernet") break;   // prefer wired
            }
        }
        type = found?.type ?? "";
        connection = found?.name ?? "";

        const active = (wifi ?? "").trim().split("\n").find(l => l.startsWith("yes:"));
        signal = active ? parseInt(active.split(":")[1]) : 0;
    }

    Process {
        id: proc
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE,CONNECTION device status; echo ---; nmcli -t -f ACTIVE,SIGNAL device wifi list --rescan no 2>/dev/null"]
        stdout: StdioCollector { onStreamFinished: root.parse(text) }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }

    Icon {
        text: root.type === "ethernet" ? Icons.ethernet
            : root.type === "wifi" ? Icons.wifi[Math.min(4, Math.ceil(root.signal / 25))]
            : Icons.disconnected
        color: root.type === "" ? Theme.red : Theme.teal
    }

    BarText {
        text: root.type === "" ? "Offline" : root.type === "ethernet" ? "Wired" : root.connection
        color: Theme.subtext
        elide: Text.ElideRight
        Layout.maximumWidth: 120
    }

    HoverHandler { cursorShape: Qt.PointingHandCursor }
    TapHandler { onTapped: Quickshell.execDetached(["nm-connection-editor"]) }
}
