import QtQuick
import QtQuick.Layouts
import Quickshell

import "file:///home/vodrech/.cache/matugen/quickshell" as Theme
import "../.."

RowLayout {
    spacing: 6

    // Quickshell built-in clock service
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // Calendar Icon
    Icon {
        text: "󰸗" // FontAwesome / Nerd Font icon
    }

    Text {
			text: Qt.formatDateTime(clock.date, "MMM  d dddd hh:mm")
				color: Theme.Colors.primary
        font.pixelSize: Core.barTextSize
    }
}
