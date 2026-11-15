pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

import qs.config as Config
import qs.services as Services
import qs.utils as Utils
import qs.widgets as Widgets

import "root:/utils/Utils.js" as UtilsJS

Widgets.Chip {
    id: root

    enum DeviceDisplayMode {
        DeviceDisplayFull,
        DeviceDisplayIconOnly,
        DeviceDisplayNone
    }

    enum DisplayMode {
        DisplayFull,
        DisplayIconOnly
    }

    enum DeviceType {
        Bluetooth,
        Hdmi,
        SoundCard,
        Usb
    }

    readonly property JsonObject settings: Config.Settings.modules.volume
    readonly property DeviceInfo deviceInfo: DeviceInfo {}

    property int deviceDisplayMode: UtilsJS.enumStringToValue(Volume.DeviceDisplayMode, "Volume.DeviceDisplayMode", settings.deviceDisplayMode, Volume.DeviceDisplayMode.DeviceDisplayIconOnly)
    property int displayMode: UtilsJS.enumStringToValue(Volume.DisplayMode, "Volume.DisplayMode", settings.displayMode, Volume.DisplayMode.DisplayFull)

    enableHover: true

    onLeftClicked: {
        if (!settings.leftClickedCmd || settings.leftClickedCmd.length == 0) {
            return;
        }
        Quickshell.execDetached(settings.leftClickedCmd);
    }

    onRightClicked: {
        Services.AudioService.toggleMute();
    }

    Component.onCompleted: {
        internal.handleSinkChanged(Services.AudioService.sink);
    }

    Connections {
        target: Services.AudioService

        function onSinkChanged() {
            internal.handleSinkChanged(Services.AudioService.sink);
        }
    }

    QtObject {
        id: internal

        function handleSinkChanged(sink) {
            if (!sink) {
                return;
            }

            const deviceApi = Services.AudioService.sink.properties["device.api"];
            const sinkName = Services.AudioService.sink.name;

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
                    return Services.AudioService.sink?.properties["media.name"] ?? "";
                } else if (root.deviceInfo.deviceType == Volume.DeviceType.Hdmi) {
                    return "HDMI";
                }
                return "SOUND CARD";
            });
        }
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
                visible: root.deviceDisplayMode == Volume.DeviceDisplayMode.DeviceDisplayFull
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

    WheelHandler {
        orientation: Qt.Vertical
        rotationScale: 15
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        // BUG: somehow the event is not fired when pressing control. Maybe it gets eaten by the compositor ?
        // acceptedModifiers: Qt.ControlModifier

        onWheel: wheelEvent => {
            Services.AudioService.changeVolume(Services.AudioService.fineVolumeStep * (wheelEvent.angleDelta.y < 0 ? -1 : 1));
            wheelEvent.accepted = true;
        }
    }

    content: Row {
        spacing: 4

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 16
            text: Services.AudioService.audioNode ? Utils.MaterialIcons.getVolumeIcon(Services.AudioService.volume, Services.AudioService.muted) : "no_sound"
        }

        Widgets.Text {
            id: levelLabel
            anchors.verticalCenter: parent.verticalCenter
            visible: root.displayMode != Volume.DisplayIconOnly && Services.AudioService.audioNode != null
            text: Utils.Display.formatPercentage(Services.AudioService.volume)
        }

        AudioDeviceChip {
            name: root.deviceInfo.name
            deviceType: root.deviceInfo.deviceType
            visible: root.deviceDisplayMode != Volume.DeviceDisplayMode.DeviceDisplayNone && root.deviceInfo.deviceType != Volume.DeviceType.SoundCard
        }
    }
}
