import QtQuick
import QtQuick.Layouts

// Group of modules in the bar, laid out in a row. Hidden when none of them are visible.
Item {
    id: root
    default property alias content: row.data
    property int padding: 14

    implicitWidth: row.implicitWidth + padding * 2
    implicitHeight: Theme.barHeight
    visible: row.visibleChildren.length > 0

    Behavior on implicitWidth { NumberAnimation { duration: Theme.animMs; easing.type: Easing.OutCubic } }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: Theme.spacing
    }
}
