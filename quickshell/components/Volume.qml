import QtQuick
import "../services"
import "file:///home/vodrech/.cache/matugen/quickshell" as Theme

Text {
    text: VolumeService.muted
        ? "󰖁"
        : "󰕾 " + VolumeService.volume + "%"

    color: Theme.Colors.foreground

    font {
        family: "JetBrainsMono Nerd Font"
        pixelSize: 15
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            VolumeService.toggleMute()
        }

        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) {
                VolumeService.increase()
            } else {
                VolumeService.decrease()
            }
        }
    }
}
