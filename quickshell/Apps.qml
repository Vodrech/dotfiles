import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets

// Open-windows button: click for a list of all windows. Click a row to focus it,
// × to end the app's whole process.
Item {
    id: root
    required property PanelWindow bar

    // Sorted by workspace, special workspaces (negative ids) last. Windows without a
    // class (Steam's XWayland menus, tooltips and notifications) are left out.
    readonly property var windows: Hyprland.toplevels.values.filter(t =>
        t.wayland?.appId || t.lastIpcObject?.class
    ).sort((a, b) => {
        const wa = a.workspace?.id ?? 0, wb = b.workspace?.id ?? 0;
        return (wa < 0) - (wb < 0) || wa - wb;
    })

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    RowLayout {
        id: row
        spacing: 6
        Icon {
            text: Icons.apps
            color: mouse.containsMouse || menu.visible ? Theme.accent : Theme.text
        }
        BarText {
            visible: root.windows.length > 0
            text: root.windows.length
            color: Theme.subtext
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
        implicitWidth: 380
        implicitHeight: content.implicitHeight + 24
        WlrLayershell.namespace: "quickshell-apps"
        // Loads each window's pid (lastIpcObject), which the × button needs.
        onOpened: Hyprland.refreshToplevels()

        ColumnLayout {
            id: content
            anchors { fill: parent; margins: 12 }
            spacing: 8

            BarText {
                text: "Open windows"
                color: Theme.accent
                font.bold: true
                Layout.leftMargin: 6
            }

            BarText {
                visible: root.windows.length === 0
                text: "No open windows"
                color: Theme.overlay0
                Layout.leftMargin: 6
            }

            ListView {
                id: list
                Layout.fillWidth: true
                implicitHeight: Math.min(contentHeight, 440)
                visible: count > 0
                clip: true
                spacing: 2
                boundsBehavior: Flickable.StopAtBounds
                model: root.windows

                delegate: Rectangle {
                    id: entry
                    required property HyprlandToplevel modelData

                    readonly property string appId: modelData.wayland?.appId || modelData.lastIpcObject?.class || ""
                    // Last part of ids like "net-runelite-client-RuneLite" or "org.wezfurlong.wezterm".
                    readonly property string shortId: appId.split(/[.-]/).pop()
                    // heuristicLookup("") returns an arbitrary entry, so skip it for empty ids.
                    readonly property DesktopEntry desktopEntry: appId
                        ? DesktopEntries.heuristicLookup(appId) ?? DesktopEntries.heuristicLookup(shortId)
                        : null
                    // First icon name that exists in the theme, or "" to show a letter instead.
                    readonly property string iconSource: {
                        for (const name of [desktopEntry?.icon, appId, appId.toLowerCase(), shortId.toLowerCase()]) {
                            const path = name ? Quickshell.iconPath(name, true) : "";
                            if (path)
                                return path;
                        }
                        return "";
                    }
                    readonly property var workspace: modelData.workspace

                    width: ListView.view.width
                    implicitHeight: 44
                    radius: 8
                    color: rowMouse.containsMouse ? Theme.surface0 : "transparent"

                    MouseArea {
                        id: rowMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Hypr.focusWindow(entry.modelData);
                            menu.close();
                        }
                    }

                    RowLayout {
                        anchors { fill: parent; leftMargin: 8; rightMargin: 6 }
                        spacing: 10

                        IconImage {
                            visible: entry.iconSource !== ""
                            implicitSize: 24
                            asynchronous: true
                            source: entry.iconSource
                        }

                        // Fallback when no icon is found: first letter of the app name.
                        Rectangle {
                            visible: entry.iconSource === ""
                            implicitWidth: 24
                            implicitHeight: 24
                            radius: 6
                            color: Theme.surface1
                            BarText {
                                anchors.centerIn: parent
                                text: nameLabel.text.charAt(0).toUpperCase()
                                font.bold: true
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            BarText {
                                id: nameLabel
                                Layout.fillWidth: true
                                text: entry.desktopEntry?.name || entry.shortId || "Unknown"
                                font.bold: true
                                elide: Text.ElideRight
                            }
                            BarText {
                                Layout.fillWidth: true
                                text: entry.modelData.title
                                color: Theme.subtext
                                font.pixelSize: Theme.fontSize - 2
                                elide: Text.ElideRight
                                visible: text.length > 0 && text !== nameLabel.text
                            }
                        }

                        // Workspace badge
                        Rectangle {
                            visible: entry.workspace !== null
                            implicitWidth: Math.max(22, wsLabel.implicitWidth + 10)
                            implicitHeight: 20
                            radius: 6
                            color: Theme.surface0
                            BarText {
                                id: wsLabel
                                anchors.centerIn: parent
                                text: (entry.workspace?.id ?? 0) < 0
                                    ? entry.workspace.name.replace(/^special:/, "")
                                    : entry.workspace?.id ?? ""
                                color: Theme.subtext
                                font.pixelSize: Theme.fontSize - 2
                            }
                        }

                        IconButton {
                            text: Icons.close
                            implicitWidth: 26
                            implicitHeight: 26
                            onClicked: Hypr.killWindowProcess(entry.modelData)
                        }
                    }
                }
            }
        }
    }
}
