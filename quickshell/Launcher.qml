import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets

// NixOS logo that opens a dropdown of favourite apps. Click a tile to launch it.
Item {
    id: root
    required property PanelWindow bar

    // Desktop entry ids (the .desktop file name without extension) of apps to show.
    // To find an id: ls /run/current-system/sw/share/applications ~/.nix-profile/share/applications
    readonly property var favorites: ["firefox", "steam", "vesktop", "Bolt"]

    // Re-resolved when the app list changes (it loads in the background at startup).
    readonly property var entries: {
        DesktopEntries.applications.values;   // dependency
        return favorites.map(id => DesktopEntries.byId(id) ?? DesktopEntries.heuristicLookup(id)).filter(e => e);
    }

    // Desktop entries of apps that currently have a window open.
    readonly property var runningEntries: Hyprland.toplevels.values.map(t => {
        const appId = t.wayland?.appId || t.lastIpcObject?.class || "";
        if (!appId)
            return null;
        return DesktopEntries.heuristicLookup(appId) ?? DesktopEntries.heuristicLookup(appId.split(/[.-]/).pop());
    })

    readonly property int columns: Math.min(4, Math.max(1, entries.length))

    implicitWidth: logo.implicitWidth
    implicitHeight: logo.implicitHeight

    Icon {
        id: logo
        text: Icons.nixos
        color: mouse.containsMouse || menu.visible ? Theme.accent : Theme.blue
        font.pixelSize: Theme.iconSize + 2
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        anchors.margins: -4
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: menu.toggle()
    }

    Dropdown {
        id: menu
        bar: root.bar
        anchorItem: root
        implicitWidth: content.implicitWidth + 24
        implicitHeight: content.implicitHeight + 24
        WlrLayershell.namespace: "quickshell-launcher"

        ColumnLayout {
            id: content
            anchors { fill: parent; margins: 12 }
            spacing: 8

            BarText {
                text: "Favorites"
                color: Theme.accent
                font.bold: true
                Layout.leftMargin: 6
            }

            BarText {
                visible: root.entries.length === 0
                text: "No favorite apps found"
                color: Theme.overlay0
                Layout.leftMargin: 6
            }

            Grid {
                columns: root.columns
                spacing: 4

                Repeater {
                    model: root.entries

                    delegate: Rectangle {
                        id: tile
                        required property DesktopEntry modelData
                        readonly property bool running: root.runningEntries.includes(modelData)

                        width: 84
                        height: 84
                        radius: 10
                        color: tileMouse.pressed ? Theme.surface1 : tileMouse.containsMouse ? Theme.surface0 : "transparent"
                        Behavior on color { ColorAnimation { duration: Theme.animMs / 2 } }

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 6

                            IconImage {
                                Layout.alignment: Qt.AlignHCenter
                                implicitSize: 36
                                asynchronous: true
                                source: Quickshell.iconPath(tile.modelData.icon, true)
                                scale: tileMouse.containsMouse ? 1.1 : 1
                                Behavior on scale { NumberAnimation { duration: Theme.animMs; easing.type: Easing.OutBack } }
                            }

                            BarText {
                                Layout.alignment: Qt.AlignHCenter
                                Layout.maximumWidth: 76
                                text: tile.modelData.name
                                font.pixelSize: Theme.fontSize - 1
                                elide: Text.ElideRight
                            }
                        }

                        // Running indicator
                        Rectangle {
                            visible: tile.running
                            anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 4 }
                            width: 14
                            height: 3
                            radius: 2
                            color: Theme.accent
                        }

                        MouseArea {
                            id: tileMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                tile.modelData.execute();
                                menu.close();
                            }
                        }
                    }
                }
            }
        }
    }
}
