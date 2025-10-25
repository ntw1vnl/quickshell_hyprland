import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import qs.style as Style
import qs.utils as Utils
import qs.widgets as Widgets

Item {
    id: root

    property real padding: 8

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audioNode: sink?.audio

    PwObjectTracker {
        objects: [sink]
    }

    property real volumeStep: 0.05
    property real fineVolumeStep: 0.01

    implicitHeight: 28
    implicitWidth: contentRow.implicitWidth + padding * 2

    function changeVolume(amount: real) {
        if (!root.audioNode) {
            return;
        }
        let volume = root.audioNode.volume + amount;
        console.log(`target volume before check = ${volume}`);
        if (volume < 0) {
            volume = 0;
        } else if (volume > 1) {
            volume = 1;
        }
        console.log(`target volume = ${volume}`);
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
            // root.changeVolume((wheelEvent.modifiers & Qt.ControlModifier ? root.fineVolumeStep : root.volumeStep) * (wheelEvent.angleDelta.y < 0 ? -1 : 1));
            root.changeVolume(root.fineVolumeStep * (wheelEvent.angleDelta.y < 0 ? -1 : 1));
            wheelEvent.accepted = true;
        }
    }

    Row {
        id: contentRow
        anchors.centerIn: parent

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            text: root.audioNode ? Utils.Icons.getVolumeIcon(root.audioNode?.volume ?? 0, root.audioNode?.muted ?? false) : "no_sound"
        }

        Widgets.Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: root.audioNode != null && !root.audioNode.muted
            text: `${Math.round(root.audioNode?.volume * 100 ?? 0)} %`
        }
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        z: contentRow.z - 1
        color: Style.Colors.surface0
        radius: height / 2
    }
}
