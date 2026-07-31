import QtQuick
import Quickshell
import Quickshell.Wayland

import "../components"

Item {
    id: root

    property bool open: false

    width: 120
    height: 32



    Rectangle {
        anchors.fill: parent

        radius: 5
        color: "#3498db"


        Text {
            anchors.centerIn: parent

            text: "Menu"

            color: "white"
        }



        MouseArea {
            anchors.fill: parent

            hoverEnabled: true


            onEntered: {
                closeTimer.stop()
                openTimer.start()
            }


            onExited: {
                openTimer.stop()
                closeTimer.start()
            }
        }
    }



    Timer {
        id: openTimer

        interval: 500


        onTriggered: {
            panel.visible = true
            root.open = true
        }
    }



    Timer {
        id: closeTimer

        interval: 300


        onTriggered: {
            if (!panelMouse.containsMouse) {
                root.open = false
                hideTimer.start()
            }
        }
    }



    Timer {
        id: hideTimer

        interval: 800


        onTriggered: {
            panel.visible = false
        }
    }



    PanelWindow {
        id: panel

        visible: false


        anchors {
            top: true
            left: true
        }


        implicitWidth: 640
        implicitHeight: 900


        color: "transparent"


        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.exclusiveZone: 0



        Rectangle {
            id: drawer


            anchors.top: parent.top
            anchors.left: parent.left


            width: root.open ? parent.width : 0
            height: parent.height


            color: "#1e1e2e"


            border.color: "#89b4fa"
            border.width: 2


            clip: true



            Behavior on width {

                NumberAnimation {

                    duration: 750

                    easing.type: Easing.OutCubic
                }
            }



            MouseArea {

                id: panelMouse

                anchors.fill: parent

                hoverEnabled: true


                onEntered: {
                    closeTimer.stop()
                }


                onExited: {
                    closeTimer.start()
                }
            }



            Column {

                anchors.fill: parent

                anchors.margins: 20

                spacing: 15



                Text {

                    text: "Quick Panel"

                    color: "white"

                    font.pixelSize: 26
                }



                Rectangle {

                    width: 300

                    height: 50

                    radius: 8

                    color: "#313244"



                    Text {

                        anchors.centerIn: parent

                        text: "Content"

                        color: "white"
                    }
                }
            }
        }
    }
}

