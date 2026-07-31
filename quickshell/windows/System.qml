// Window for displaying the System
import Quickshell
import QtQuick

import "../services"
import "../components/base"
import "file:///home/vodrech/.cache/matugen/quickshell" as Theme

PanelWindow {
    id: window

    width: 400
    height: 800

    visible: true

    color: "transparent"

    anchors {
        left: true
        top: true
			}

    Rectangle {
        id: content

        width: parent.width
        height: parent.height
        color: Theme.Colors.background

        x: window.visible ? 0 : -width

        Behavior on x {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
					}

					Column {

						anchors.centerIn: parent
						spacing: 10
						topPadding: 0

						Rectangle {
							width: 300
							height: 40
							color: "transparent"

							Heading {
								text: "NixOS"
								color: Theme.Colors.primary
							}
						}

						Rectangle {
							width: 300
							height: 300
							color: "transparent"

							Image {
								id: icon

								anchors.fill: parent
								anchors.centerIn: parent

								source: "../assets/systemIcon.svg"
								fillMode: Image.PreserveAspectFit
							}
						}

						Rectangle {
							width: 300
							height: 40
							color: "transparent"
						}

						Rectangle {
							width: 300
							height: 40
							color: "transparent"
						}

					}

    }
}
/*
 *
						Image {
							id: icon
							anchors.centerIn: parent
							width: 250
							height: 250
							source: "../assets/systemIcon.svg"
							fillMode: Image.PreserveAspectFit
						}

						Text {
							anchors.centerIn: parent
							text: "wowwho"
						}
						*/
