// Core Configurations & Constants

pragma Singleton
import QtQuick

QtObject {
    readonly property string assets:
		"file:///home/vodrech/.assets"

		// Bar Configurations
		readonly property int barHeight: 32
		readonly property int barZone: 32
		readonly property int barTextSize: 13

		readonly property int barIconSmall: 13
		readonly property int barIconMedium: 16
		readonly property int barIconLarge: 22
}
