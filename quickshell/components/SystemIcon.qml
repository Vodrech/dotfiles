import QtQuick
import "../config"
import "../components/base/bar"
import "file:///home/vodrech/.cache/matugen/quickshell" as Theme

Item {
	id: root

	height: 32
	width: 32

	signal clicked()

	Text {
		anchors.centerIn: parent
    text: ""
		font.pixelSize: 20
	}

	MouseArea {
		anchors.fill: parent
		onClicked: {
			console.log("icon cliked")
			root.clicked()
		}
	}
}
