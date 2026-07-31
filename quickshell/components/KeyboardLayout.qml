import QtQuick
import "../services"
import "file:///home/vodrech/.cache/matugen/quickshell" as Theme

Text {
		text: "   " + KeyboardLayoutService.layout.toUpperCase()
    color: Theme.Colors.foreground
		font.pixelSize: 12

		MouseArea {
      anchors.fill: parent
      onClicked: KeyboardLayoutService.nextLayout()
		}
}
