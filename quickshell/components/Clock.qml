import QtQuick
import "../services" as Services
import "file:///home/vodrech/.cache/matugen/quickshell" as Theme

Column {
    Text {
        text: Services.ClockService.time
				font.pixelSize: 16
        color: Theme.Colors.primary
    }

    Text {
        text: Services.ClockService.date
				font.pixelSize: 12
        color: Theme.Colors.primary
    }
}
