import QtQuick

// Single-line text input styled to match the bar.
Rectangle {
    id: root
    property alias text: input.text
    property alias input: input
    property string placeholder
    property bool invalid: false
    signal accepted()
    signal escaped()

    implicitHeight: 30
    radius: 8
    color: Theme.mantle
    border.width: 1
    border.color: invalid ? Theme.red : input.activeFocus ? Theme.accent : Theme.surface0
    Behavior on border.color { ColorAnimation { duration: Theme.animMs } }

    TextInput {
        id: input
        anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
        verticalAlignment: TextInput.AlignVCenter
        clip: true
        color: Theme.text
        font.family: Theme.font
        font.pixelSize: Theme.fontSize
        selectByMouse: true
        selectionColor: Theme.accent
        selectedTextColor: Theme.crust
        onAccepted: root.accepted()
        Keys.onEscapePressed: root.escaped()
    }

    BarText {
        anchors.fill: input
        text: root.placeholder
        color: Theme.overlay0
        visible: input.text.length === 0
    }
}
