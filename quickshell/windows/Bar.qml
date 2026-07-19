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

		// Left
		Row {
			spacing: 12
			anchors {
				left: parent.left
				leftMargin: 12
				verticalCenter: parent.verticalCenter
			}

			SystemIcon {}

			Workspaces {}

		}

		// Center
		Clock {
			anchors.centerIn: parent
		}

		// Right
		Row {
			spacing: 12
			anchors {
				right: parent.right
				rightMargin: 12
				verticalCenter: parent.verticalCenter
			}

			KeyboardLayout {}
			Volume {}
		}
	}
}
