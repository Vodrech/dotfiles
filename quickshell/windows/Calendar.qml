// --- Dynamic Calendar Overlay with Month Switching & Weekend Styling ---
    PanelWindow {
        id: calendarPopup
        
        screen: Quickshell.screens[0]
        visible: root.calendarVisible

        anchors {
            top: true
        }
        
        margins.top: bar.height + 8
        
        width: calendarCard.width
        height: calendarCard.height

        color: "transparent"

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-calendar"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
        exclusionMode: ExclusionMode.Ignore

        // Track currently active month & year
        property date displayedDate: new Date()
        property date selectedDate: new Date()

        // Helper functions for switching months
        function changeMonth(delta) {
            let d = new Date(displayedDate.getFullYear(), displayedDate.getMonth() + delta, 1);
            displayedDate = d;
        }

        // Event database formatted as "YYYY-MM-DD"
        property var events: {
            "2026-07-31": [
                { title: "NixOS Config Review", color: "#89b4fa" },
                { title: "Team Sync @ 3 PM", color: "#a6e3a1" }
            ],
            "2026-08-05": [
                { title: "System Maintenance", color: "#f38ba8" }
            ],
            "2026-08-15": [
                { title: "Project Launch", color: "#fab387" }
            ]
        }

        function formatDateKey(d) {
            let yyyy = d.getFullYear();
            let mm = String(d.getMonth() + 1).padStart(2, '0');
            let dd = String(d.getDate()).padStart(2, '0');
            return `${yyyy}-${mm}-${dd}`;
        }

        Rectangle {
            id: calendarCard
            width: 320
            height: selectedEventsList.count > 0 ? 410 : 340
            radius: 12
            color: "#181825"
            border.color: "#45475a"
            border.width: 1

            Behavior on height { NumberAnimation { duration: 150 } }

            HoverHandler {
                id: calendarHover
                onHoveredChanged: {
                    if (hovered) {
                        calendarCloseTimer.stop()
                        root.calendarVisible = true
                    } else {
                        calendarCloseTimer.restart()
                    }
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8

                // --- 1. MONTH NAVIGATION HEADER (< Month Year >) ---
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    // Previous Month Button
                    Rectangle {
                        width: 26
                        height: 26
                        radius: 6
                        color: prevMouse.containsMouse ? "#313244" : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "❮"
                            color: "#a6adc8"
                            font.pixelSize: 11
                        }

                        MouseArea {
                            id: prevMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: calendarPopup.changeMonth(-1)
                        }
                    }

                    // Month & Year Display
                    Text {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        color: "#cdd6f4"
                        font.pixelSize: 15
                        font.bold: true
                        text: Qt.formatDateTime(calendarPopup.displayedDate, "MMMM yyyy")
                    }

                    // Next Month Button
                    Rectangle {
                        width: 26
                        height: 26
                        radius: 6
                        color: nextMouse.containsMouse ? "#313244" : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "❯"
                            color: "#a6adc8"
                            font.pixelSize: 11
                        }

                        MouseArea {
                            id: nextMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: calendarPopup.changeMonth(1)
                        }
                    }
                }

                // --- 2. DAYS OF WEEK HEADER ---
                DayOfWeekRow {
                    Layout.fillWidth: true
                    delegate: Text {
                        text: model.shortName
                        // Highlight Saturday / Sunday headers differently from weekdays
                        color: (model.day === Qt.Saturday || model.day === Qt.Sunday) ? "#f5e0dc" : "#a6adc8"
                        font.pixelSize: 11
                        font.bold: model.day === Qt.Saturday || model.day === Qt.Sunday
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                // --- 3. MONTH GRID WITH WEEKEND ACCENTS ---
                MonthGrid {
                    id: grid
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    month: calendarPopup.displayedDate.getMonth()
                    year: calendarPopup.displayedDate.getFullYear()

                    delegate: Item {
                        required property var model
                        
                        // Check day properties
                        property bool isCurrentMonth: model.month === grid.month
                        property bool isWeekend: model.date.getDay() === 0 || model.date.getDay() === 6
                        property string dateKey: calendarPopup.formatDateKey(model.date)
                        property var dayEvents: isCurrentMonth ? (calendarPopup.events[dateKey] || []) : []
                        property bool isSelected: isCurrentMonth && calendarPopup.formatDateKey(calendarPopup.selectedDate) === dateKey

                        // Background Highlight
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 2
                            radius: 6
                            visible: parent.isCurrentMonth
                            color: parent.isSelected ? "#313244" : "transparent"
                            border.color: model.today ? "#89b4fa" : (parent.isSelected ? "#cdd6f4" : "transparent")
                            border.width: 1
                        }

                        // Date Text Number
                        Text {
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: parent.dayEvents.length > 0 ? -4 : 0
                            text: parent.isCurrentMonth ? model.day : ""
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            visible: parent.isCurrentMonth
                            font.bold: model.today || parent.isSelected || parent.isWeekend
                            
                            // Color Logic: Today (Blue) > Weekend (Peach/Warm) > Weekday (Light Lavender)
                            color: model.today ? "#89b4fa" : (parent.isWeekend ? "#fab387" : "#cdd6f4")
                        }

                        // Event Indicator Dots
                        Row {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottomMargin: 4
                            spacing: 3
                            visible: parent.isCurrentMonth && parent.dayEvents.length > 0

                            Repeater {
                                model: Math.min(parent.parent.dayEvents.length, 3)
                                Rectangle {
                                    width: 4
                                    height: 4
                                    radius: 2
                                    color: parent.parent.parent.dayEvents[index].color || "#89b4fa"
                                }
                            }
                        }

                        // Click Handler
                        MouseArea {
                            anchors.fill: parent
                            enabled: parent.isCurrentMonth
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                calendarPopup.selectedDate = model.date
                            }
                        }
                    }
                }

                // --- 4. EVENT DETAILS LIST AT BOTTOM ---
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: "#313244"
                    visible: selectedEventsList.count > 0
                }

                ListView {
                    id: selectedEventsList
                    Layout.fillWidth: true
                    Layout.preferredHeight: count > 0 ? 60 : 0
                    clip: true
                    spacing: 4

                    model: calendarPopup.events[calendarPopup.formatDateKey(calendarPopup.selectedDate)] || []

                    delegate: RowLayout {
                        width: selectedEventsList.width
                        spacing: 8

                        Rectangle {
                            width: 8
                            height: 8
                            radius: 4
                            color: modelData.color || "#89b4fa"
                        }

                        Text {
                            text: modelData.title
                            color: "#cdd6f4"
                            font.pixelSize: 11
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }
    }
