import Quickshell
import QtQuick
import QtQuick.Layouts

import "../components"
import "file:///home/vodrech/.cache/matugen/quickshell" as Theme

PanelWindow {
	id: popup
  property bool open: false

	anchors {
		top: true
		left: true
	}

	implicitWidth: 640
	implicitHeight: 1080

	color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: "#313244"
        radius: 10

        Column {
            anchors {
                fill: parent
                margins: 15
            }

            spacing: 10

            Text {
                text: "Settings"
                color: "white"
                font.pixelSize: 18
            }

            Button {
                text: "Reload"
            }

            Button {
                text: "Quit"
            }
        }
    }
}
