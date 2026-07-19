pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

QtObject {
    property var sink: Pipewire.defaultAudioSink

    property int volume: 0
    property bool muted: false

    function update() {
        if (!sink || !sink.ready)
            return

        volume = Math.round(sink.audio.volume * 100)
        muted = sink.audio.muted
    }

    function toggleMute() {
        if (!sink || !sink.ready)
            return

        sink.audio.muted = !sink.audio.muted
        update()
    }

    function increase() {
        if (!sink || !sink.ready)
            return

        sink.audio.volume = Math.min(
            sink.audio.volume + 0.05,
            1.0
        )

        update()
    }

    function decrease() {
        if (!sink || !sink.ready)
            return

        sink.audio.volume = Math.max(
            sink.audio.volume - 0.05,
            0.0
        )

        update()
    }

    property Timer updateTimer: Timer {
        interval: 500
        running: true
        repeat: true

        onTriggered: update()
    }

    property Connections pipewireEvents: Connections {
        target: Pipewire

        function onDefaultAudioSinkChanged() {
            sink = Pipewire.defaultAudioSink
            update()
        }
    }
}
