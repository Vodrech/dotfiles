import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

// Date + time; click to open a month calendar with appointments.
Item {
    id: root
    required property PanelWindow bar

    property int viewMonth: clock.date.getMonth()
    property int viewYear: clock.date.getFullYear()
    property date selectedDate: clock.date
    readonly property string selectedKey: Appointments.key(selectedDate)

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    function resetMonth() {
        selectDate(clock.date);
    }

    function selectDate(d: date) {
        selectedDate = d;
        viewMonth = d.getMonth();
        viewYear = d.getFullYear();
    }

    function addFromFields() {
        const title = titleField.text.trim();
        const time = Appointments.parseTime(timeField.text);
        if (title === "" || time === null)
            return;
        Appointments.add(selectedKey, time, title);
        titleField.text = "";
        timeField.text = "";
        timeField.input.forceActiveFocus();
    }

    function shiftMonth(delta: int) {
        const d = new Date(viewYear, viewMonth + delta, 1);
        viewMonth = d.getMonth();
        viewYear = d.getFullYear();
    }

    SystemClock { id: clock; precision: SystemClock.Seconds }

    RowLayout {
        id: row
        spacing: 8
        Icon { text: Icons.clock; color: Theme.accent }
        BarText { text: Qt.formatDateTime(clock.date, "HH:mm"); font.bold: true }
        BarText { text: Qt.formatDateTime(clock.date, "ddd d MMM"); color: Theme.subtext }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: popup.toggle()
    }

    Dropdown {
        id: popup
        bar: root.bar
        implicitWidth: 300
        implicitHeight: cal.implicitHeight + 28
        WlrLayershell.namespace: "quickshell-calendar"

        onOpened: {
            root.resetMonth();
            timeField.input.forceActiveFocus();
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            onWheel: wheel => root.shiftMonth(wheel.angleDelta.y > 0 ? -1 : 1)
        }

        ColumnLayout {
            id: cal
            anchors { fill: parent; margins: 14 }
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                IconButton {
                    text: Icons.chevronLeft
                    onClicked: root.shiftMonth(-1)
                }
                BarText {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDate(new Date(root.viewYear, root.viewMonth, 1), "MMMM yyyy")
                    font.bold: true
                    color: titleMouse.containsMouse ? Theme.accent : Theme.text

                    // Click the title to jump back to the current month.
                    MouseArea {
                        id: titleMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.resetMonth()
                    }
                }
                IconButton {
                    text: Icons.chevronRight
                    onClicked: root.shiftMonth(1)
                }
            }

            DayOfWeekRow {
                Layout.fillWidth: true
                locale: grid.locale
                delegate: BarText {
                    required property string shortName
                    text: shortName.slice(0, 2)
                    color: Theme.overlay0
                    font.pixelSize: Theme.fontSize - 1
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            MonthGrid {
                id: grid
                Layout.fillWidth: true
                month: root.viewMonth
                year: root.viewYear

                // MonthGrid exposes its model roles individually, not as a `model` object.
                delegate: Rectangle {
                    id: cell
                    required property date date
                    required property int day
                    required property int month
                    required property bool today

                    readonly property string key: Appointments.key(date)
                    readonly property bool selected: key === root.selectedKey
                    readonly property bool hasEvents: Appointments.hasEvents(key)

                    implicitWidth: 30
                    implicitHeight: 30
                    radius: 8
                    color: today ? Theme.accent : cellMouse.containsMouse ? Theme.surface0 : "transparent"
                    border.width: selected && !today ? 1 : 0
                    border.color: Theme.accent

                    BarText {
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: cell.hasEvents ? -2 : 0
                        text: cell.day
                        font.bold: cell.today
                        color: cell.today ? Theme.crust
                             : cell.month === grid.month ? Theme.text
                             : Theme.surface1
                    }

                    // Marks days that have appointments.
                    Rectangle {
                        visible: cell.hasEvents
                        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 4 }
                        width: 4
                        height: 4
                        radius: 2
                        color: cell.today ? Theme.crust : Theme.peach
                    }

                    MouseArea {
                        id: cellMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.selectDate(cell.date)
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: 2
                implicitHeight: 1
                color: Theme.surface0
            }

            BarText {
                text: Qt.formatDate(root.selectedDate, "dddd d MMMM")
                color: Theme.accent
                font.bold: true
            }

            Repeater {
                id: dayEvents
                model: Appointments.eventsOn(root.selectedKey)

                delegate: RowLayout {
                    id: event
                    required property var modelData
                    Layout.fillWidth: true
                    spacing: 10

                    BarText {
                        text: event.modelData.time || "all day"
                        color: Theme.blue
                        font.pixelSize: Theme.fontSize - 1
                        Layout.preferredWidth: 52
                    }
                    BarText {
                        text: event.modelData.title
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    IconButton {
                        text: Icons.close
                        implicitWidth: 24
                        implicitHeight: 24
                        onClicked: Appointments.remove(event.modelData.uid)
                    }
                }
            }

            BarText {
                visible: dayEvents.count === 0
                text: "No appointments"
                color: Theme.overlay0
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 2
                spacing: 6

                Field {
                    id: timeField
                    Layout.preferredWidth: 70
                    placeholder: "HH:MM"
                    invalid: Appointments.parseTime(text) === null
                    onAccepted: titleField.input.forceActiveFocus()
                    onEscaped: popup.visible = false
                }
                Field {
                    id: titleField
                    Layout.fillWidth: true
                    placeholder: "Add appointment…"
                    onAccepted: root.addFromFields()
                    onEscaped: popup.visible = false
                }
            }
        }
    }
}
