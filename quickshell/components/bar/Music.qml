import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Io

Item {
    id: volumeRoot
    implicitWidth: barContent.implicitWidth
    implicitHeight: barContent.implicitHeight

    property bool popupVisible: false
    property int volumeLevel: 50
    property bool isMuted: false

    PwObjectTracker {
        objects: [ Pipewire.nodes ]
    }

    Process {
        id: getVolProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(" ")
                if (parts.length >= 2) {
                    let vol = Math.round(parseFloat(parts[1]) * 100)
                    if (!isNaN(vol)) volumeRoot.volumeLevel = vol
                    volumeRoot.isMuted = data.includes("[MUTED]")
                }
            }
        }
    }

    Process { id: setVolProc }
    Process { id: appVolProc }

    function syncVolume() {
        if (!getVolProc.running) getVolProc.running = true
    }

    function setMasterVolume(val) {
        val = Math.max(0, Math.min(100, val))
        volumeRoot.volumeLevel = val
        setVolProc.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", `${val}%`]
        setVolProc.running = true
    }

    function setAppVolume(nodeId, volumePct) {
        appVolProc.command = ["wpctl", "set-volume", `${nodeId}`, `${volumePct}%`]
        appVolProc.running = true
    }

    function toggleMute() {
        volumeRoot.isMuted = !volumeRoot.isMuted
        setVolProc.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        setVolProc.running = true
    }

    Component.onCompleted: volumeRoot.syncVolume()
    Timer {
        interval: 1500
        running: true
        repeat: true
        onTriggered: volumeRoot.syncVolume()
    }

    Timer {
        id: closeDelayTimer
        interval: 300
        repeat: false
        onTriggered: {
            if (!barMouseArea.containsMouse && !popupMouseArea.containsMouse) {
                volumeRoot.popupVisible = false
            }
        }
    }

    function keepOpen() {
        closeDelayTimer.stop()
        volumeRoot.popupVisible = true
    }

    function checkClose() {
        closeDelayTimer.restart()
    }

    function getVolumeIcon() {
        if (volumeRoot.isMuted || volumeRoot.volumeLevel === 0) return "󰝟"
        if (volumeRoot.volumeLevel < 33) return "󰕿"
        if (volumeRoot.volumeLevel < 66) return "󰖀"
        return "󰕾"
    }

    // STATUS BAR WIDGET
    RowLayout {
        id: barContent
        spacing: 6

        Text {
            text: volumeRoot.getVolumeIcon()
            color: volumeRoot.popupVisible ? "#87d6bd" : "#dee4e0"
            font.pixelSize: 15
        }

        Text {
            text: volumeRoot.isMuted ? "Muted" : `${volumeRoot.volumeLevel}%`
            color: volumeRoot.popupVisible ? "#87d6bd" : "#dee4e0"
            font.pixelSize: 13
            font.weight: Font.Medium
        }
    }

    MouseArea {
        id: barMouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: volumeRoot.keepOpen()
        onExited: volumeRoot.checkClose()
        onClicked: volumeRoot.toggleMute()

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) volumeRoot.setMasterVolume(volumeRoot.volumeLevel + 5)
            else volumeRoot.setMasterVolume(volumeRoot.volumeLevel - 5)
        }
    }

    // POPUP CONTROL MENU
    PanelWindow {
        id: volumePopup
        screen: Quickshell.screens[0]
        visible: volumeRoot.popupVisible
        width: 320
        height: mainColumn.implicitHeight + 24
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-volume-popup"

        anchors { top: true; left: true }
        margins {
            top: barContent.height + 4
            left: volumeRoot.mapToItem(null, 0, 0).x - (width / 2) + (volumeRoot.width / 2)
        }

        MouseArea {
            id: popupMouseArea
            anchors.fill: parent
            hoverEnabled: true

            onEntered: volumeRoot.keepOpen()
            onExited: volumeRoot.checkClose()

            Rectangle {
                anchors.fill: parent
                radius: 12
                color: "#0f1512"
                border.color: "#3f4945"
                border.width: 1

                ColumnLayout {
                    id: mainColumn
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12

                    // 1. MASTER VOLUME
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Master Volume"
                            color: "#89938e"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: volumeRoot.isMuted ? "Muted" : `${volumeRoot.volumeLevel}%`
                            color: volumeRoot.isMuted ? "#89938e" : "#87d6bd"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                        }
                    }

                    Item {
                        id: sliderTrack
                        Layout.fillWidth: true
                        implicitHeight: 16

                        Rectangle {
                            anchors.left: parent.left; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                            height: 6; radius: 3; color: "#344c43"
                        }
                        Rectangle {
                            anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * (volumeRoot.volumeLevel / 100); height: 6; radius: 3
                            color: volumeRoot.isMuted ? "#5e6964" : "#87d6bd"
                        }
                        Rectangle {
                            x: Math.max(0, Math.min(sliderTrack.width - width, (sliderTrack.width * (volumeRoot.volumeLevel / 100)) - (width / 2)))
                            anchors.verticalCenter: parent.verticalCenter
                            width: 14; height: 14; radius: 7; color: "#dee4e0"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: mouse => { volumeRoot.keepOpen(); updateSlider(mouse.x); }
                            onPositionChanged: mouse => { if (pressed) { volumeRoot.keepOpen(); updateSlider(mouse.x); } }
                            onReleased: volumeRoot.checkClose()

                            function updateSlider(mouseX) {
                                let pct = Math.round((mouseX / sliderTrack.width) * 100)
                                volumeRoot.setMasterVolume(pct)
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: "#2a352f" }

                    // 2. PLAYING APPLICATIONS LIST
                    Text {
                        text: "Playing Applications"
                        color: "#89938e"
                        font.pixelSize: 10
                        font.weight: Font.Bold
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Repeater {
                            model: Pipewire.nodes

                            delegate: Item {
                                id: appItem
                                required property PwNode modelData

                                PwObjectTracker {
                                    objects: [ appItem.modelData ]
                                }

                                readonly property var props: (modelData && modelData.properties) ? modelData.properties : {}

                                readonly property string appTitle: {
                                    if (!modelData) return ""
                                    if (props["application.name"]) return props["application.name"]
                                    if (modelData.description && modelData.description !== "") return modelData.description
                                    if (modelData.nickname && modelData.nickname !== "") return modelData.nickname
                                    if (props["media.name"]) return props["media.name"]
                                    return modelData.name || ""
                                }

                                readonly property string mediaClass: {
                                    if (!modelData || !modelData.type) return ""
                                    return String(modelData.type)
                                }

                                readonly property bool isAppPlaybackStream: {
                                    if (!modelData) return false
                                    if (!modelData.audio) return false
                                    if (!modelData.isStream) return false

                                    let mClass = mediaClass.toLowerCase()
                                    if (mClass.includes("stream/input")) return false

                                    let title = appTitle.toLowerCase()
                                    let rawName = (modelData.name || "").toLowerCase()
                                    let appProcess = (props["application.process.binary"] || "").toLowerCase()

                                    // Filter out system utility apps, volume controllers, and monitors
                                    if (title === "" ||
                                        title.includes("peak") ||
                                        title.includes("monitor") ||
                                        title.includes("quickshell") ||
                                        title.includes("wireplumber") ||
                                        title.includes("pavucontrol") ||
                                        title.includes("pulse audio controller") ||
                                        rawName.includes("pavucontrol") ||
                                        appProcess.includes("pavucontrol")) {
                                        return false
                                    }

                                    return true
                                }

                                readonly property real currentVol: (appItem.modelData && appItem.modelData.audio) 
                                                                    ? appItem.modelData.audio.volume 
                                                                    : 1.0

                                visible: isAppPlaybackStream
                                Layout.fillWidth: true
                                implicitHeight: isAppPlaybackStream ? appBox.implicitHeight : 0

                                ColumnLayout {
                                    id: appBox
                                    anchors.fill: parent
                                    spacing: 4

                                    RowLayout {
                                        Layout.fillWidth: type

                                        Text {
                                            text: "󰎆 " + appItem.appTitle
                                            color: "#dee4e0"
                                            font.pixelSize: 11
                                            font.weight: Font.Medium
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            text: `${Math.round(appItem.currentVol * 100)}%`
                                            color: "#87d6bd"
                                            font.pixelSize: 10
                                            font.weight: Font.Bold
                                        }
                                    }

                                    Item {
                                        id: appSliderTrack
                                        Layout.fillWidth: true
                                        implicitHeight: 14

                                        Rectangle {
                                            anchors.left: parent.left; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                                            height: 4; radius: 2; color: "#2a352f"
                                        }

                                        Rectangle {
                                            anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                                            width: parent.width * appItem.currentVol
                                            height: 4; radius: 2; color: "#87d6bd"
                                        }

                                        Rectangle {
                                            x: Math.max(0, Math.min(appSliderTrack.width - width, (appSliderTrack.width * appItem.currentVol) - (width / 2)))
                                            anchors.verticalCenter: parent.verticalCenter
                                            width: 10; height: 10; radius: 5; color: "#dee4e0"
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onPressed: mouse => { volumeRoot.keepOpen(); updateAppSlider(mouse.x); }
                                            onPositionChanged: mouse => { if (pressed) { volumeRoot.keepOpen(); updateAppSlider(mouse.x); } }
                                            onReleased: volumeRoot.checkClose()

                                            function updateAppSlider(mouseX) {
                                                let pct = Math.max(0, Math.min(100, Math.round((mouseX / appSliderTrack.width) * 100)))
                                                
                                                if (appItem.modelData && appItem.modelData.audio) {
                                                    appItem.modelData.audio.volume = pct / 100.0
                                                }
                                                if (appItem.modelData) {
                                                    volumeRoot.setAppVolume(appItem.modelData.id, pct)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
