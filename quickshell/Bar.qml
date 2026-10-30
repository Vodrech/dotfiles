import QtQuick
import Quickshell

PanelWindow {
    id: bar
    required property ShellScreen modelData

    screen: modelData
    anchors { top: true; left: true; right: true }
    margins { top: Theme.gap; left: Theme.gap; right: Theme.gap }
    implicitHeight: Theme.barHeight
    color: "transparent"

    Island {
        anchors.left: parent.left
        Launcher { bar: bar }
        Apps { bar: bar }
        Workspaces { shellScreen: bar.screen }
        WindowTitle {}
    }

    Island {
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
