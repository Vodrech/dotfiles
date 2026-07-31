// Attaches to the parent window
import QtQuick
import QtQuick.Layouts

import "../../services"

ColumnLayout {
	id: networkTab

	anchors.horizontalCenter: parent.horizontalCenter
	anchors.top: parent.top
	anchors.topMargin: 16

	spacing: 12

	Text {
		text: "Network"
		color: "white"
	}
}
