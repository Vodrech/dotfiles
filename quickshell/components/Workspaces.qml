import QtQuick
import "../services"
import "file:///home/vodrech/.cache/matugen/quickshell" as Theme

Row {
    spacing: 6

    Repeater {
        model: WorkspaceService.workspaces

        Rectangle {
            width: 24
            height: 24
            radius: 12

            color: WorkspaceService.isActive(modelData.id)
                ? Theme.Colors.primary
                : Theme.Colors.foreground

            Text {
                anchors.centerIn: parent
                text: modelData.id
                color: Theme.Colors.text
            }

            MouseArea {
                anchors.fill: parent
                onClicked: WorkspaceService.switchTo(modelData.id)
            }
        }
    }
}
