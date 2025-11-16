pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.Pipewire

import "../utils" as Utils
import "../widgets" as Widgets

Widgets.Chip {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audioNode: sink?.audio

    PwObjectTracker {
        objects: [root.sink]
    }

    property real volumeStep: 0.05
    property real fineVolumeStep: 0.01

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
    }

    TapHandler {
        id: tapHandler
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onTapped: (eventPoint, button) => {
            if (button == Qt.RightButton && root.audioNode) {
                root.audioNode.muted = !root.audioNode.muted;
            }
        }
    }

    WheelHandler {
        orientation: Qt.Vertical
        rotationScale: 15
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        // BUG: somehow the event is not fired when pressing control. Maybe it gets eaten by the compositor ?
        // acceptedModifiers: Qt.ControlModifier

        onWheel: wheelEvent => {
            root.changeVolume(root.fineVolumeStep * (wheelEvent.angleDelta.y < 0 ? -1 : 1));
            wheelEvent.accepted = true;
        }
    }

    content: Row {
        spacing: 4

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 16
            text: root.audioNode ? Utils.MaterialIcons.getVolumeIcon(root.audioNode?.volume ?? 0, root.audioNode?.muted ?? false) : "no_sound"
        }

        Widgets.Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: root.audioNode != null && !root.audioNode.muted
            text: `${Math.round(root.audioNode?.volume * 100 ?? 0)} %`
        }
    }
}
