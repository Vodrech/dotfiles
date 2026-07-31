import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland

import "file:///home/vodrech/.cache/matugen/quickshell" as Theme

import "../windows/tabs"
import "../components/base"

// Temp import
import "../services"

PanelWindow {
	id: root

	width: 400
	height: 800

	property int currentTab: 0
	property var tabs: [
		{name: "Audio", index: 0},
		{name: "Network", index: 1},
		{name: "Keyboard", index: 2}
	]

	anchors {
		right: true
		top: true
	}

	color: Theme.Colors.background

	function setCurrentTab(val: int) {
		root.currentTab = val
	}

	// Wrapper
	ColumnLayout {

		anchors.fill: parent

		RowLayout {

			anchors.top: parent.top
			anchors.topMargin: 15

			Repeater {
				model: root.tabs
				delegate: Button {
					background_color: root.currentTab == modelData.index ? 
					Theme.Colors.primary : Theme.Colors.outline
					text_color: Theme.Colors.primary
					buttonText: modelData.name
					active: root.currentTab == modelData.index
					onClicked: setCurrentTab(modelData.index)
				}
			}
		}

		// Content Container
		StackLayout {
			currentIndex: root.currentTab

			AudioTab {}
			NetworkTab {}
			KeyboardTab {}
		}
	}

	Border {}
}
