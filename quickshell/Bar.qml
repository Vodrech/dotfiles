import QtQuick
import Quickshell

PanelWindow {
    id: bar
    required property ShellScreen modelData

    screen: modelData
    anchors { top: true; left: true; right: true }
    margins { top: Theme.barMargin; left: Theme.barMargin; right: Theme.barMargin }
    implicitHeight: Theme.barHeight
    color: "transparent"

    // One continuous bar; the modules sit on it in three groups.
    Rectangle {
        anchors.fill: parent
        color: Theme.base

        Rectangle {
            anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
            height: 1
            color: Theme.surface0
        }
    }

    Island {
        anchors.left: parent.left
        Launcher { bar: bar }
        Apps { bar: bar }
        Workspaces { shellScreen: bar.screen }
        WindowTitle {}
    }

    // Just left of the clock, so the clock stays centred.
    Island {
        anchors.right: center.left
        padding: 0
        TextPreview { bar: bar }
    }

    Island {
        id: center
        anchors.horizontalCenter: parent.horizontalCenter
        Clock { bar: bar }
    }

    Island {
        anchors.right: parent.right
        Tray { bar: bar }
        ClaudeUsage { bar: bar }
        SysStats {}
        Network {}
        Keyboard { bar: bar }
        Volume { bar: bar }
    }
}
