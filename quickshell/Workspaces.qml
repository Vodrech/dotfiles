import QtQuick
import Quickshell
import Quickshell.Hyprland

// Pill-style workspace indicator: active = wide accent pill, occupied = bright dot, empty = dim dot.
Item {
    id: root
    required property ShellScreen shellScreen

    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(shellScreen)
    readonly property int activeId: monitor?.activeWorkspace?.id ?? 1
    // Always show 1..5, plus any higher-numbered workspace that exists.
    readonly property int count: Math.max(5, ...Hyprland.workspaces.values.filter(w => w.id > 0).map(w => w.id))

    implicitWidth: row.implicitWidth
    implicitHeight: Theme.barHeight

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Repeater {
            model: root.count

            delegate: Rectangle {
                id: ws
                required property int index
                readonly property int wsId: index + 1
                readonly property HyprlandWorkspace workspace: Hyprland.workspaces.values.find(w => w.id === wsId) ?? null
                readonly property bool active: root.activeId === wsId
                readonly property bool occupied: (workspace?.toplevels?.values.length ?? 0) > 0
                readonly property bool urgent: workspace?.urgent ?? false

                anchors.verticalCenter: parent.verticalCenter
                width: active ? 28 : 10
                height: 10
                radius: height / 2
                color: urgent ? Theme.red
                     : active ? Theme.accent
                     : hover.hovered ? Theme.overlay0
                     : occupied ? Theme.subtext
                     : Theme.surface1

                Behavior on width { NumberAnimation { duration: Theme.animMs; easing.type: Easing.OutBack } }
                Behavior on color { ColorAnimation { duration: Theme.animMs } }

                HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }
                TapHandler { onTapped: Hypr.focusWorkspace(ws.wsId) }
            }
        }
    }

    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: e => Hypr.focusWorkspace(e.angleDelta.y > 0 ? "m-1" : "m+1")
    }
}
