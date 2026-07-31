// Attaches to the parent window
import QtQuick
import QtQuick.Layouts

import "../../services"
import "../../components/base"

ColumnLayout {
	id: audioTab

	anchors.horizontalCenter: parent.horizontalCenter
	anchors.top: parent.top
	anchors.topMargin: 16

	spacing: 12

	Slider {
		anchors.horizontalCenter: parent.horizontalCenter
	}

	Repeater {
		model: AudioService.outputDevices

		Text {
			text: modelData.description
			color: "white"
		}
	}

	Text {
		text: AudioService.defaultSink.description
		color: "white"
	}


	ColumnLayout {
		id: outputs
	}
}
