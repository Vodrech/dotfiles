import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland

// Keyboard layout, from Hyprland's input config (kb_layout / kb_variant). Click for a list
// to switch layouts, scroll to cycle. Switching applies to all keyboards.
RowLayout {
    id: root
    required property PanelWindow bar
    spacing: 6

    // [{ layout: "us", variant: "colemak" }, ...] and the active index, from the main keyboard.
    property var layouts: []
    property int active: 0

    // "Colemak" for a variant, otherwise the layout code: "US", "SE".
    function label(l): string {
        return l.variant ? l.variant.charAt(0).toUpperCase() + l.variant.slice(1) : l.layout.toUpperCase();
    }

    function select(index: int) {
        Quickshell.execDetached(["hyprctl", "switchxkblayout", "all", String(index)]);
    }

    function parse(out: string) {
        try {
            const keyboards = JSON.parse(out).keyboards;
            const kb = keyboards.find(k => k.main) ?? keyboards[0];
            if (!kb)
                return;
            const names = kb.layout.split(","), variants = kb.variant.split(",");
            layouts = names.map((layout, i) => ({ layout: layout.trim(), variant: (variants[i] ?? "").trim() }));
            active = kb.active_layout_index;
        } catch (e) {}
    }

    visible: layouts.length > 0

    Process {
        id: proc
        command: ["hyprctl", "devices", "-j"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.parse(text) }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activelayout" || event.name === "configreloaded")
                proc.running = true;
        }
    }

    Icon {
        text: Icons.keyboard
        color: mouse.containsMouse || menu.visible ? Theme.accent : Theme.sky
    }

    BarText {
        text: root.layouts.length > 0 ? root.label(root.layouts[root.active] ?? root.layouts[0]) : ""
        color: Theme.subtext
    }

    HoverHandler { id: mouse; cursorShape: Qt.PointingHandCursor }
    TapHandler { onTapped: menu.toggle() }
    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: e => {
            const n = root.layouts.length;
            if (n > 1)
                root.select((root.active + (e.angleDelta.y > 0 ? -1 : 1) + n) % n);
        }
    }

    Dropdown {
        id: menu
        bar: root.bar
        anchorItem: root
        implicitWidth: 240
        implicitHeight: content.implicitHeight + 24
        WlrLayershell.namespace: "quickshell-keyboard"

        ColumnLayout {
            id: content
            anchors { fill: parent; margins: 12 }
            spacing: 2

            RowLayout {
                Layout.leftMargin: 6
                Layout.bottomMargin: 4
                spacing: 8
                Icon { text: Icons.keyboard; color: Theme.accent; font.pixelSize: Theme.iconSize - 2 }
                BarText { text: "Keyboard layout"; color: Theme.accent; font.bold: true }
            }

            Repeater {
                model: root.layouts

                delegate: Rectangle {
                    id: row
                    required property var modelData
                    required property int index
                    readonly property bool current: index === root.active

                    Layout.fillWidth: true
                    implicitHeight: 34
                    radius: 8
                    color: rowMouse.containsMouse ? Theme.surface0 : "transparent"

                    RowLayout {
                        anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                        spacing: 10

                        Icon {
                            text: Icons.check
                            color: Theme.green
                            font.pixelSize: Theme.iconSize - 2
                            opacity: row.current ? 1 : 0
                        }
                        BarText {
                            Layout.fillWidth: true
                            text: root.label(row.modelData)
                            color: row.current ? Theme.text : Theme.subtext
                            font.bold: row.current
                        }
                        BarText {
                            text: row.modelData.layout + (row.modelData.variant ? " · " + row.modelData.variant : "")
                            color: Theme.overlay0
                            font.pixelSize: Theme.fontSize - 2
                        }
                    }

                    MouseArea {
                        id: rowMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.select(row.index);
                            menu.close();
                        }
                    }
                }
            }
        }
    }
}
