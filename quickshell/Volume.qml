import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Wayland
import Quickshell.Widgets

// Default output volume. Scroll to adjust, left-click for the device picker,
// middle-click to mute, right-click for pavucontrol.
RowLayout {
    id: root
    required property PanelWindow bar
    spacing: 6

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? true

    // Hardware devices only; streams are apps playing or recording.
    readonly property var sinks: Pipewire.nodes.values.filter(n => n.audio && n.isSink && !n.isStream)
    readonly property var sources: Pipewire.nodes.values.filter(n => n.audio && !n.isSink && !n.isStream)
    // Apps playing audio (playback streams count as sinks).
    readonly property var streams: Pipewire.nodes.values.filter(n => n.audio && n.isStream && n.isSink)

    PwObjectTracker { objects: [root.sink, root.source].concat(root.streams) }

    // WirePlumber remembers a device per app once it has been moved (target.object), and
    // such apps ignore the default. Clearing it makes them follow the new default.
    function followDefault(playback: bool) {
        for (const n of Pipewire.nodes.values) {
            if (n.audio && n.isStream && n.isSink === playback)   // playback streams count as sinks
                Quickshell.execDetached(["pw-metadata", "-d", String(n.id), "target.object"]);
        }
    }

    Icon {
        text: root.muted || root.volume === 0 ? Icons.volumeOff
            : root.volume < 0.34 ? Icons.volumeLow
            : root.volume < 0.67 ? Icons.volumeMedium
            : Icons.volumeHigh
        color: root.muted ? Theme.overlay0 : mouse.containsMouse || menu.visible ? Theme.accent : Theme.yellow
    }

    BarText {
        text: root.muted ? "Muted" : Math.round(root.volume * 100) + "%"
        color: root.muted ? Theme.overlay0 : Theme.text
        Layout.minimumWidth: 36
    }

    HoverHandler { id: mouse; cursorShape: Qt.PointingHandCursor }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: menu.toggle()
    }
    TapHandler {
        acceptedButtons: Qt.MiddleButton
        onTapped: if (root.sink?.audio) root.sink.audio.muted = !root.sink.audio.muted
    }
    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: Quickshell.execDetached(["pavucontrol"])
    }
    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: e => {
            if (!root.sink?.audio) return;
            const step = e.angleDelta.y > 0 ? 0.05 : -0.05;
            root.sink.audio.volume = Math.max(0, Math.min(1, root.volume + step));
            root.sink.audio.muted = false;
        }
    }

    Dropdown {
        id: menu
        bar: root.bar
        anchorItem: root
        implicitWidth: 460
        implicitHeight: content.implicitHeight + 24
        WlrLayershell.namespace: "quickshell-audio"

        ColumnLayout {
            id: content
            anchors { fill: parent; margins: 12 }
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                DeviceList {
                    title: "Output"
                    icon: Icons.speaker
                    nodes: root.sinks
                    current: root.sink
                    onSelected: node => {
                        Pipewire.preferredDefaultAudioSink = node;
                        root.followDefault(true);
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    implicitWidth: 1
                    color: Theme.surface0
                }

                DeviceList {
                    title: "Input"
                    icon: Icons.microphone
                    nodes: root.sources
                    current: root.source
                    onSelected: node => {
                        Pipewire.preferredDefaultAudioSource = node;
                        root.followDefault(false);
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: Theme.surface0
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                RowLayout {
                    Layout.leftMargin: 6
                    spacing: 8
                    Icon { text: Icons.apps; color: Theme.accent; font.pixelSize: Theme.iconSize - 2 }
                    BarText { text: "Applications"; color: Theme.accent; font.bold: true }
                }

                BarText {
                    visible: root.streams.length === 0
                    text: "Nothing is playing"
                    color: Theme.overlay0
                    Layout.leftMargin: 6
                }

                Repeater {
                    model: root.streams
                    delegate: AppVolume {}
                }
            }
        }
    }

    component DeviceList: ColumnLayout {
        id: list
        property string title
        property string icon
        property var nodes: []
        property PwNode current
        signal selected(PwNode node)

        Layout.fillWidth: true
        Layout.preferredWidth: 1    // equal columns
        Layout.alignment: Qt.AlignTop
        spacing: 2

        RowLayout {
            Layout.leftMargin: 6
            Layout.bottomMargin: 4
            spacing: 8
            Icon { text: list.icon; color: Theme.accent; font.pixelSize: Theme.iconSize - 2 }
            BarText { text: list.title; color: Theme.accent; font.bold: true }
        }

        BarText {
            visible: list.nodes.length === 0
            text: "No devices"
            color: Theme.overlay0
            Layout.leftMargin: 6
        }

        Repeater {
            model: list.nodes

            delegate: Rectangle {
                id: device
                required property PwNode modelData
                readonly property bool active: modelData === list.current

                Layout.fillWidth: true
                implicitHeight: 34
                radius: 8
                color: deviceMouse.containsMouse ? Theme.surface0 : "transparent"

                RowLayout {
                    anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                    spacing: 10

                    Icon {
                        text: Icons.check
                        color: Theme.green
                        font.pixelSize: Theme.iconSize - 2
                        opacity: device.active ? 1 : 0
                    }
                    BarText {
                        Layout.fillWidth: true
                        text: device.modelData.nickname || device.modelData.description || device.modelData.name
                        color: device.active ? Theme.text : Theme.subtext
                        font.bold: device.active
                        elide: Text.ElideRight
                    }
                }

                MouseArea {
                    id: deviceMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: list.selected(device.modelData)
                }
            }
        }
    }

    // Volume slider: click or drag to set, scroll to step by 5%.
    component VolumeSlider: Item {
        id: slider
        property real value
        property bool muted
        signal moved(real value)

        implicitHeight: 14

        function set(x: real) {
            moved(Math.max(0, Math.min(1, x / width)));
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: 6
            radius: 3
            color: Theme.surface0

            Rectangle {
                width: parent.width * Math.min(1, slider.value)
                height: parent.height
                radius: 3
                color: slider.muted ? Theme.overlay0 : Theme.accent
            }
        }

        Rectangle {
            x: slider.width * Math.min(1, slider.value) - width / 2
            anchors.verticalCenter: parent.verticalCenter
            width: 12
            height: 12
            radius: 6
            color: slider.muted ? Theme.overlay0 : Theme.text
            visible: sliderMouse.containsMouse || sliderMouse.pressed
        }

        MouseArea {
            id: sliderMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onPressed: e => slider.set(e.x)
            onPositionChanged: e => { if (pressed) slider.set(e.x); }
            onWheel: e => slider.moved(Math.max(0, Math.min(1, slider.value + (e.angleDelta.y > 0 ? 0.05 : -0.05))))
        }
    }

    component AppVolume: RowLayout {
        id: app
        required property PwNode modelData
        readonly property var props: modelData.properties ?? {}
        readonly property string rawName: props["application.name"] || modelData.nickname || modelData.name
        // heuristicLookup("") returns an arbitrary entry, so skip it for empty names.
        readonly property DesktopEntry desktopEntry: rawName ? DesktopEntries.heuristicLookup(rawName) : null
        readonly property string appName: desktopEntry?.name || rawName
        readonly property string media: props["media.name"] ?? ""
        readonly property real volume: modelData.audio?.volume ?? 0
        readonly property bool muted: modelData.audio?.muted ?? false
        // First icon name that exists in the theme, or "" to show a letter instead.
        readonly property string iconSource: {
            for (const name of [desktopEntry?.icon, props["application.icon-name"], props["application.process.binary"], rawName.toLowerCase()]) {
                const path = name ? Quickshell.iconPath(name, true) : "";
                if (path)
                    return path;
            }
            return "";
        }

        Layout.fillWidth: true
        Layout.leftMargin: 6
        spacing: 10

        IconImage {
            visible: app.iconSource !== ""
            implicitSize: 24
            asynchronous: true
            source: app.iconSource
        }

        Rectangle {
            visible: app.iconSource === ""
            implicitWidth: 24
            implicitHeight: 24
            radius: 6
            color: Theme.surface1
            BarText {
                anchors.centerIn: parent
                text: app.appName.charAt(0).toUpperCase()
                font.bold: true
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                BarText {
                    text: app.appName
                    font.bold: true
                }
                BarText {
                    id: mediaLabel
                    Layout.fillWidth: true
                    visible: app.media !== "" && app.media.toLowerCase() !== app.appName.toLowerCase()
                    text: app.media
                    color: Theme.overlay0
                    font.pixelSize: Theme.fontSize - 2
                    elide: Text.ElideRight
                }
                Item { Layout.fillWidth: true; visible: !mediaLabel.visible }
                BarText {
                    Layout.alignment: Qt.AlignRight
                    text: app.muted ? "Muted" : Math.round(app.volume * 100) + "%"
                    color: app.muted ? Theme.overlay0 : Theme.subtext
                    font.pixelSize: Theme.fontSize - 1
                }
            }

            VolumeSlider {
                Layout.fillWidth: true
                value: app.volume
                muted: app.muted
                onMoved: v => {
                    if (!app.modelData.audio) return;
                    app.modelData.audio.volume = v;
                    app.modelData.audio.muted = false;
                }
            }
        }

        IconButton {
            text: app.muted ? Icons.volumeOff : Icons.volumeHigh
            onClicked: if (app.modelData.audio) app.modelData.audio.muted = !app.modelData.audio.muted
        }
    }
}
