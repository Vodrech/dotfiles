// Bar Icon
import Quickshell
import QtQuick

import "file:///home/vodrech/.cache/matugen/quickshell" as Theme
import "../../"

Text {
	id: root
	property string size: "medium"

	font.pixelSize: {
		if(size === "small")
		  return Core.barIconSmall
		if(size === "large")
		  return Core.barIconLarge
		return Core.barIconMedium // Default
	}

	color: Theme.Colors.primary

}

