// The Activity Widget

import QtQuick
import Quickshell.Hyprland

import "file:///home/vodrech/.cache/matugen/quickshell" as Theme
import "../../"

Text {
	text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : "<missing>"
	font.pixelSize: Core.barTextSize
	color: Theme.Colors.primary
}
