// Handles the Workspace Widget

import QtQuick
import "../../services"
import "../../" // Core

import "file:///home/vodrech/.cache/matugen/quickshell" as Theme

Row {
    spacing: 6

    Repeater {
        model: WorkspaceService.workspaces

        Rectangle {
            width: Core.barHeight - 10
            height: Core.barHeight - 10
						radius: 3

            color: WorkspaceService.isActive(modelData.id)
                ? Theme.Colors.primary
                : Theme.Colors.surfaceVariant

            Text {
                anchors.centerIn: parent
                text: modelData.id
                color: Theme.Colors.background
            }

            MouseArea {
                anchors.fill: parent
                onClicked: WorkspaceService.switchTo(modelData.id)
            }
        }
    }
}
