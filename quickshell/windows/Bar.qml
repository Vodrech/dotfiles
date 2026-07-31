import Quickshell
import QtQuick
import QtQuick.Layouts

import "../components"
import "../components/base/bar"

import "file:///home/vodrech/.cache/matugen/quickshell" as Theme

PanelWindow {
	id: bar

	signal settingsClicked()
	signal systemClicked()

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

			BarItem {
				itemIcon: ""
				onClicked: {
					bar.systemClicked()
				}
			}

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

			BarCategory {
				onClicked: {
					bar.settingsClicked()
				}
				BarItem {
					itemIcon: ""
				}

				BarItem {
					itemIcon: "󰂯"
				}

				BarItem {
					itemIcon: ""
				}
			}

			BarItem {
				itemIcon: ""
				itemColor: "#fa0040"
			}

		}
	}
}
