import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

ColumnLayout {
    id: root
    spacing: 12

    // Stores active layout key ("us", "se", "cmk")
    property string currentLayout: "us"

    property var keyboardLayouts: [
        { id: "us", name: "English (US)", flag: "🇺🇸", index: 0 },
        { id: "se", name: "Swedish (SWE)", flag: "🇸🇪", index: 1 },
        { id: "cmk", name: "Colemak (CMK)", flag: "⌨️", index: 2 }
    ]

    // Switch layout by sending Hyprland dispatcher command
    function setKeyboardLayout(item) {
        root.currentLayout = item.id;
        Hyprland.dispatch("switchxkblayout all " + item.index);
    }

    // Listen to real-time Hyprland layout switch events (e.g., when changed via keybind)
    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activelayout") {
                var data = event.data.toLowerCase();
                if (data.includes("colemak")) {
                    root.currentLayout = "cmk";
                } else if (data.includes("swedish") || data.includes("se")) {
                    root.currentLayout = "se";
                } else {
                    root.currentLayout = "us";
                }
            }
        }
    }

    // Header
    RowLayout {
        Layout.fillWidth: true

        Text {
            text: "Select Layout"
            color: "#cdd6f4"
            font.pixelSize: 14
            font.bold: true
        }

        Item { Layout.fillWidth: true }

        Rectangle {
            color: "#313244"
            radius: 4
            implicitWidth: 42
            implicitHeight: 20

            Text {
                anchors.centerIn: parent
                text: root.currentLayout.toUpperCase()
                color: "#89b4fa"
                font.pixelSize: 10
                font.bold: true
            }
        }
    }

    // Column List View
    ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true

        ListView {
            id: layoutList
            model: root.keyboardLayouts
            spacing: 8

            delegate: Rectangle {
                required property var modelData

                width: layoutList.width
                height: 48
                radius: 8
                color: (root.currentLayout === modelData.id) ? "#313244" : "#181825"
                border.color: (root.currentLayout === modelData.id) ? "#89b4fa" : "transparent"
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.setKeyboardLayout(modelData)
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12

                    Text {
                        text: modelData.flag
                        font.pixelSize: 18
                    }

                    Text {
                        text: modelData.name
                        color: (root.currentLayout === modelData.id) ? "#89b4fa" : "#cdd6f4"
                        font.pixelSize: 13
                        font.bold: root.currentLayout === modelData.id
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Text {
                        text: "✓"
                        color: "#89b4fa"
                        font.pixelSize: 14
                        font.bold: true
                        visible: root.currentLayout === modelData.id
                    }
                }
            }
        }
    }
}
