import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

// StatusNotifier system tray. Left = activate, middle = secondary, right = menu.
Row {
    id: root
    required property PanelWindow bar

    spacing: 10
    visible: SystemTray.items.values.length > 0

    Repeater {
        model: SystemTray.items

        delegate: MouseArea {
            id: item
            required property SystemTrayItem modelData

            width: Theme.iconSize
            height: Theme.iconSize
            anchors.verticalCenter: parent.verticalCenter
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
            cursorShape: Qt.PointingHandCursor

            onClicked: e => {
                if (e.button === Qt.MiddleButton) {
                    modelData.secondaryActivate();
                } else if (e.button === Qt.LeftButton && !modelData.onlyMenu) {
                    modelData.activate();
                } else if (modelData.hasMenu) {
                    const p = mapToItem(root.bar.contentItem, 0, 0);
                    modelData.display(root.bar, p.x, root.bar.height + Theme.gap);
                }
            }

            IconImage {
                anchors.fill: parent
                source: item.modelData.icon
                asynchronous: true
            }
        }
    }
}
