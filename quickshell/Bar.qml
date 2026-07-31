// This is placed in the root as it should always be shown
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "./components/bar"
import "file:///home/vodrech/.cache/matugen/quickshell" as Theme

PanelWindow {
    id: bar
    
    // Target the primary display
    screen: Quickshell.screens[0]

    // Anchor to the top edge of the monitor
    anchors {
        top: true
        left: true
        right: true
    }
    
    // Bar height
    height: Core.barHeight

    // Make window background transparent for rounded corners
    color: "transparent"

    // Wayland Layer Shell settings
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell-bar"

    // Visual Bar Rectangle
    Rectangle {
        anchors.fill: parent
        anchors.margins: 2
        radius: 8
        color: Theme.Colors.background
        // border.color: Theme.Colors.foreground
        // border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12

            // 1. LEFT SECTION (Grouped together so center stays dead-centered!)
            RowLayout {
                spacing: 8

                Icon {
                    text: ""
                    size: "large"
                }

                Workspace {}

								Activity {
									Layout.preferredWidth: 0
									Layout.fillWidth: false
								}
            }

            // Left Spacer (expands equally)
            Item { Layout.fillWidth: true }

						Date {
							anchors.centerIn: parent
						}

						Item { Layout.fillWidth: true }

						Music {}

						Keyboard {}

            // 3. RIGHT SECTION (Grouped for consistency)
            RowLayout {
                spacing: 8


            }
        }
    }
}
