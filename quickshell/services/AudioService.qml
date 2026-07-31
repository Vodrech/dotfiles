pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Item {
    id: root

    readonly property PwNode defaultSink: Pipewire.defaultAudioSink
    readonly property PwNode defaultSource: Pipewire.defaultAudioSource

		readonly property list<PwNode> outputDevices: Pipewire.nodes.values.filter(node
		  => node.isSink && !node.isStream && node.audio !== null
    )
    readonly property list<PwNode> inputDevices: Pipewire.nodes.values.filter(node => 
        !node.isSink && !node.isStream && node.audio !== null
    )

    readonly property real sinkVolume: defaultSink?.audio ? defaultSink.audio.volume : 0.0
    readonly property bool sinkMuted: defaultSink?.audio ? defaultSink.audio.muted : false
    
    readonly property real sourceVolume: defaultSource?.audio ? defaultSource.audio.volume : 0.0
    readonly property bool sourceMuted: defaultSource?.audio ? defaultSource.audio.muted : false

    PwObjectTracker {
        objects: [ root.defaultSink, root.defaultSource ]
    }

    // Device Switching Functions
    function setOutputDevice(node: PwNode) {
        if (node) Pipewire.preferredDefaultAudioSink = node
    }

    function setInputDevice(node: PwNode) {
        if (node) Pipewire.preferredDefaultAudioSource = node
    }

    // Default Output (Sink) Controls
    function setSinkVolume(value: real) {
        if (defaultSink?.audio) {
            defaultSink.audio.volume = Math.max(0.0, Math.min(1.0, value))
        }
    }

    function toggleSinkMute() {
        if (defaultSink?.audio) {
            defaultSink.audio.muted = !defaultSink.audio.muted
        }
    }

    // Default Input (Source) Controls
    function setSourceVolume(value: real) {
        if (defaultSource?.audio) {
            defaultSource.audio.volume = Math.max(0.0, Math.min(1.0, value))
        }
    }

    function toggleSourceMute() {
        if (defaultSource?.audio) {
            defaultSource.audio.muted = !defaultSource.audio.muted
        }
    }
}
