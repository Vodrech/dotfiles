import QtQuick
import Quickshell
import Quickshell.Io

import "file:///home/vodrech/.cache/matugen/quickshell" as Theme

MouseArea {
    id: root
    implicitWidth: 44
    implicitHeight: parent ? parent.height : 30

    property var layouts: ["US", "SE", "CMK"]
    property int currentIndex: 0

    Component.onCompleted: {
        layoutProc.running = true;
    }

    onClicked: {
        // Just command the switch; let Hyprland handle the order and let the process sync the UI accurately
        switchProc.command = ["hyprctl", "switchxkblayout", "all", "next"];
        switchProc.running = true;
        
        // Fetch the updated state immediately after triggering the switch
        layoutProc.running = true;
    }

    Process {
        id: switchProc
        running: false
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: layoutProc.running = true
    }

    Process {
        id: layoutProc
        command: ["hyprctl", "devices", "-j"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let data = JSON.parse(this.text);
                    let keyboards = data.keyboards || [];
                    for (let i = 0; i < keyboards.length; i++) {
                        if (keyboards[i].main === true) {
                            let name = keyboards[i].active_keymap.toLowerCase();
                            
                            if (name.includes("colemak")) {
                                root.currentIndex = 2;
                            } else if (name.includes("swedish") || name.includes("sweden") || name.includes("se")) {
                                root.currentIndex = 1;
                            } else {
                                root.currentIndex = 0;
                            }
                            break;
                        }
                    }
                } catch (e) {
                    // Ignore parsing errors
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: parent.containsMouse ? "#33ffffff" : "transparent"
        radius: 4

        Text {
            id: layoutText
            anchors.centerIn: parent
            text: "  " + root.layouts[root.currentIndex]
            color: Theme.Colors.primary
            font.pixelSize: 12
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
