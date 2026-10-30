import QtQuick
import QtQuick.Layouts

// Rounded, floating container that the bar's modules sit in.
Rectangle {
    id: root
    default property alias content: row.data
    property int padding: 14

    implicitWidth: row.implicitWidth + padding * 2
    implicitHeight: Theme.barHeight
    radius: Theme.radius
    color: Theme.base
    border.width: 1
    border.color: Theme.surface0
    visible: row.visibleChildren.length > 0

    Behavior on implicitWidth { NumberAnimation { duration: Theme.animMs; easing.type: Easing.OutCubic } }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: Theme.spacing
    }
}
