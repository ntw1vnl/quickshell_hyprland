pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

import "../config" as Config
import "../utils" as Utils
import "../widgets" as Widgets

Widgets.Chip {
    id: root

    enum DeviceDisplayMode {
        DisplayFull,
        DisplayIconOnly,
        DisplayNone
    }

    enum DeviceType {
        Bluetooth,
        Hdmi,
        SoundCard,
        Usb
    }

    readonly property JsonObject settings: Config.Settings.modules.volume
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audioNode: sink?.audio
    readonly property real volume: audioNode?.volume ?? 0
    readonly property bool muted: audioNode?.muted ?? true
    readonly property DeviceInfo deviceInfo: DeviceInfo {}

    property real volumeStep: 0.05
    property real fineVolumeStep: 0.01
    property int displayMode: internal.getDisplayModeFromString(settings.displayMode) ?? Volume.DisplayIconOnly

    enableHover: true

    onLeftClicked: {
        if (!settings.leftClickedCmd || settings.leftClickedCmd.length == 0) {
            return;
        }
        Quickshell.execDetached(settings.leftClickedCmd);
    }

    onRightClicked: {
        if (root.audioNode) {
            root.audioNode.muted = !root.audioNode.muted;
        }
    }

    QtObject {
        id: internal

        function getDisplayModeFromString(value: string): int {
            // BUG: using Qt.enumStringToValue seems to cause crashes
            switch (value) {
            case "DisplayFull":
                return Volume.DisplayFull;
            case "DisplayIconOnly":
                return Volume.DisplayIconOnly;
            case "DisplayNone":
                return Volume.DisplayNone;
            }
            return undefined;
        }
    }

    PwObjectTracker {
        objects: [root.sink]
    }

    component DeviceInfo: QtObject {
        property int deviceType: Volume.DeviceType.SoundCard
        property string name: ""
    }

    component AudioDeviceChip: Widgets.Chip {
        id: chip
        height: root.height - root.padding * 2
        bgColor: Config.Settings.colors.green

        required property string name
        required property int deviceType

        property color foreground: Config.Settings.colors.bgDark

        content: Row {
            anchors.centerIn: parent
            spacing: 4

            Widgets.Text {
                anchors.verticalCenter: parent.verticalCenter
                visible: root.displayMode == Volume.DeviceDisplayMode.DisplayFull
                color: chip.foreground
                text: chip.name
                font.pointSize: 10
            }

            Widgets.MaterialIcon {
                anchors.verticalCenter: parent.verticalCenter
                text: {
                    switch (chip.deviceType) {
                    case Volume.DeviceType.Bluetooth:
                        return "bluetooth";
                    case Volume.DeviceType.Hdmi:
                        return "monitor";
                    case Volume.DeviceType.Usb:
                        return "usb";
                    default:
                        break;
                    }
                    return "";
                }
                color: chip.foreground
                font.pointSize: 12
            }
        }
    }

    onSinkChanged: {
        if (!sink) {
            return;
        }
        const deviceApi = sink.properties["device.api"];
        const sinkName = sink.name;

        root.deviceInfo.deviceType = Qt.binding(() => {
            if (sinkName.includes('bluez')) {
                return Volume.DeviceType.Bluetooth;
            } else if (sinkName.includes('hdmi')) {
                return Volume.DeviceType.Hdmi;
            } else if (sinkName.includes('analog-stereo')) {
                return Volume.DeviceType.SoundCard;
            } else if (sinkName.includes('usb')) {
                return Volume.DeviceType.Usb;
            }
            console.warn(`could not determine audio device type. name = ${sinkName}. Using default value SoundCard`);
        });

        root.deviceInfo.name = Qt.binding(() => {
            if (root.deviceInfo.deviceType == Volume.DeviceType.Bluetooth) {
                return sink?.properties["media.name"] ?? "";
            } else if (root.deviceInfo.deviceType == Volume.DeviceType.Hdmi) {
                return "HDMI";
            }
            return "SOUND CARD";
        });
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
            text: root.audioNode ? Utils.MaterialIcons.getVolumeIcon(root.volume, root.muted) : "no_sound"
        }

        Widgets.Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: root.audioNode != null //&& !root.audioNode.muted
            text: Utils.Display.formatPercentage(root.volume)
        }

        AudioDeviceChip {
            name: root.deviceInfo.name
            deviceType: root.deviceInfo.deviceType
            visible: root.displayMode != Volume.DeviceDisplayMode.DisplayNone && deviceType != Volume.DeviceType.SoundCard
        }
    }
}
