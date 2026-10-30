import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Claude Code context and plan usage. Reads the JSON that claude-statusline.sh saves each
// time Claude Code updates its status line (see README). Hidden until data exists.
Item {
    id: root
    required property PanelWindow bar

    property var status: null
    readonly property real now: clock.date.getTime() / 1000

    readonly property real context: status?.context_window?.used_percentage ?? -1
    readonly property var fiveHour: status?.rate_limits?.five_hour ?? null
    readonly property var sevenDay: status?.rate_limits?.seven_day ?? null
    // No status update for 10 minutes: probably no active session, so dim the numbers.
    readonly property bool stale: status !== null && now - (status.updated_at ?? 0) > 600

    function usageColor(percent: real): color {
        return percent >= 90 ? Theme.red : percent >= 70 ? Theme.peach : Theme.text;
    }

    function barColor(percent: real): color {
        return percent >= 90 ? Theme.red : percent >= 70 ? Theme.peach : Theme.claude;
    }

    function formatTokens(n: real): string {
        return n >= 1000000 ? (n / 1000000).toFixed(1).replace(/\.0$/, "") + "M"
             : n >= 1000 ? Math.round(n / 1000) + "k"
             : String(Math.round(n));
    }

    function formatDuration(seconds: real): string {
        if (seconds <= 0)
            return "now";
        const d = Math.floor(seconds / 86400), h = Math.floor(seconds % 86400 / 3600), m = Math.floor(seconds % 3600 / 60);
        return d > 0 ? `${d}d ${h}h` : h > 0 ? `${h}h ${m}m` : `${m}m`;
    }

    visible: status !== null
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    SystemClock { id: clock; precision: SystemClock.Minutes }

    FileView {
        id: file
        path: Quickshell.env("XDG_RUNTIME_DIR") + "/claude-bar/status.json"
        watchChanges: true
        onFileChanged: reload()
        printErrors: false      // the file doesn't exist until Claude Code first runs the script
        onLoaded: {
            try {
                root.status = JSON.parse(text());
            } catch (e) {}
        }
    }

    // The script replaces the file with a rename, which a file watcher can miss.
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: file.reload()
    }

    RowLayout {
        id: row
        spacing: 6
        opacity: root.stale ? 0.5 : 1

        BarText {
            text: "✻"
            color: mouse.containsMouse || menu.visible ? Theme.accent : Theme.claude
            font.pixelSize: Theme.iconSize
        }
        // "5-hour|weekly" limit usage.
        RowLayout {
            spacing: 2
            BarText {
                visible: root.fiveHour !== null
                text: Math.round(root.fiveHour?.used_percentage ?? 0)
                color: root.usageColor(root.fiveHour?.used_percentage ?? 0)
            }
            BarText {
                visible: root.fiveHour !== null && root.sevenDay !== null
                text: "|"
                color: Theme.overlay0
            }
            BarText {
                visible: root.sevenDay !== null
                text: Math.round(root.sevenDay?.used_percentage ?? 0)
                color: root.usageColor(root.sevenDay?.used_percentage ?? 0)
            }
        }
        UsageBar {
            visible: root.fiveHour !== null
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: 40
            percent: root.fiveHour?.used_percentage ?? 0
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: menu.toggle()
    }

    Dropdown {
        id: menu
        bar: root.bar
        anchorItem: root
        implicitWidth: 300
        implicitHeight: details.implicitHeight + 28
        WlrLayershell.namespace: "quickshell-claude"

        ColumnLayout {
            id: details
            anchors { fill: parent; margins: 14 }
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                BarText {
                    text: "✻ " + (root.status?.model?.display_name ?? "Claude")
                    color: Theme.claude
                    font.bold: true
                }
                Item { Layout.fillWidth: true }
                BarText {
                    text: root.stale ? "updated " + root.formatDuration(root.now - root.status.updated_at) + " ago" : "active"
                    color: root.stale ? Theme.overlay0 : Theme.green
                    font.pixelSize: Theme.fontSize - 2
                }
            }

            BarText {
                Layout.fillWidth: true
                visible: text.length > 0
                text: (root.status?.workspace?.current_dir ?? "").replace(Quickshell.env("HOME"), "~")
                color: Theme.subtext
                font.pixelSize: Theme.fontSize - 1
                elide: Text.ElideMiddle
            }

            UsageMeter {
                visible: root.context >= 0
                label: "Context"
                percent: root.context
                detail: {
                    const size = root.status?.context_window?.context_window_size ?? 0;
                    return size > 0 ? root.formatTokens(size * root.context / 100) + " / " + root.formatTokens(size) : "";
                }
            }

            UsageMeter {
                visible: root.fiveHour !== null
                label: "5-hour limit"
                percent: root.fiveHour?.used_percentage ?? 0
                detail: root.fiveHour?.resets_at ? "resets in " + root.formatDuration(root.fiveHour.resets_at - root.now) : ""
            }

            UsageMeter {
                visible: root.sevenDay !== null
                label: "Weekly limit"
                percent: root.sevenDay?.used_percentage ?? 0
                detail: root.sevenDay?.resets_at ? "resets in " + root.formatDuration(root.sevenDay.resets_at - root.now) : ""
            }

            BarText {
                visible: root.fiveHour === null && root.sevenDay === null
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: "Plan limits appear after the first reply in a session (Pro/Max plans only)."
                color: Theme.overlay0
                font.pixelSize: Theme.fontSize - 2
            }
        }
    }

    component UsageBar: Rectangle {
        id: usageBar
        property real percent

        implicitHeight: 6
        radius: 3
        color: Theme.surface0

        Rectangle {
            width: parent.width * Math.min(1, Math.max(0, usageBar.percent / 100))
            height: parent.height
            radius: 3
            color: root.barColor(usageBar.percent)
            Behavior on width { NumberAnimation { duration: Theme.animMs; easing.type: Easing.OutCubic } }
        }
    }

    component UsageMeter: ColumnLayout {
        id: meter
        property string label
        property real percent
        property string detail

        Layout.fillWidth: true
        spacing: 5

        RowLayout {
            Layout.fillWidth: true
            BarText { text: meter.label; color: Theme.subtext }
            Item { Layout.fillWidth: true }
            BarText {
                text: meter.detail
                color: Theme.overlay0
                font.pixelSize: Theme.fontSize - 2
            }
            BarText {
                text: Math.round(meter.percent) + "%"
                color: root.usageColor(meter.percent)
                font.bold: true
            }
        }

        UsageBar {
            Layout.fillWidth: true
            percent: meter.percent
        }
    }
}
