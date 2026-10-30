import QtQuick

// Clickable glyph with a rounded hover background.
Rectangle {
    id: root
    property alias text: glyph.text
    signal clicked()

    implicitWidth: 28
    implicitHeight: 28
    radius: 8
    color: mouse.pressed ? Theme.surface1 : mouse.containsMouse ? Theme.surface0 : "transparent"
    Behavior on color { ColorAnimation { duration: Theme.animMs / 2 } }

    Icon {
        id: glyph
        anchors.centerIn: parent
        color: mouse.containsMouse ? Theme.accent : Theme.subtext
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
