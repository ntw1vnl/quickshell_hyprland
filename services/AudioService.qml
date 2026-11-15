pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    property real volumeStep: 0.05
    property real fineVolumeStep: 0.01

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audioNode: sink?.audio
    readonly property real volume: audioNode?.volume ?? 0
    readonly property bool muted: audioNode?.muted ?? true

    signal displayOsdRequested

    PwObjectTracker {
        objects: [root.sink]
    }

    function volumeUp() {
        changeVolume(volumeStep);
    }

    function volumeUpFine() {
        changeVolume(fineVolumeStep);
    }

    function volumeDown() {
        changeVolume(-volumeStep);
    }

    function volumeDownFine() {
        changeVolume(-fineVolumeStep);
    }

    function changeVolume(amount: real) {
        if (!root.audioNode) {
            return;
        }
        let volume = root.audioNode.volume + amount;
        if (volume < 0) {
            volume = 0;
        } else if (volume > 1) {
            volume = 1;
        }
        root.audioNode.volume = volume;
        root.displayOsdRequested()
    }

    function toggleMute() {
        if (!root.audioNode) {
            return;
        }
        root.audioNode.muted = !root.audioNode.muted;
        root.displayOsdRequested()
    }
}
