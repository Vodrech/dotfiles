import Quickshell
import QtQuick
import QtQuick.Layouts

import "../components"
import "file:///home/vodrech/.cache/matugen/quickshell" as Theme

PanelWindow {
	id: bar

	anchors {
		top: true
		left: true
		right: true
	}

	implicitHeight: 32
	exclusiveZone: 32

	Rectangle {
		anchors.fill: parent
		color: Theme.Colors.background

		Row {
			anchors.fill: parent
			anchors.leftMargin: 12
			anchors.rightMargin: 12
			spacing: 12

			SystemIcon {}

			Clock {}
		}
	}
}
