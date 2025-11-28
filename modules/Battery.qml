pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

import "../config" as Config
import "../utils" as Utils
import "../widgets" as Widgets

Widgets.Chip {
    id: root

    enum DisplayMode {
        DisplayFull, // name + icon + level
        DisplayIcon, // icon + level
        DisplayIconOnly, // icon
        DisplayNone
    }

    readonly property JsonObject settings: Config.Settings.modules.battery
    readonly property var displayDevice: UPower.displayDevice
    readonly property var devices: UPower.devices
    readonly property bool charging: root.displayDevice.state == UPowerDeviceState.Charging
    readonly property real chargeLevel: root.displayDevice.percentage

    property int defaultDisplayMode: Battery.DisplayMode.DisplayFull
    property int displayMode: internal.getDisplayModeFromString(settings.displayMode) ?? defaultDisplayMode
    property bool ignoreBluetoothDevices: settings.ignoreBluetoothDevices
    property color foreground: charging ? Config.Style.colors.green : Utils.Display.batteryLevelTextColor(chargeLevel)

    enableHover: true

    onLeftClicked: {
        if (!settings.leftClickedCmd || settings.leftClickedCmd.length == 0) {
            return;
        }
        Quickshell.execDetached(settings.leftClickedCmd);
    }

    onRightClicked: {
        if (!settings.rightClickedCmd || settings.rightClickedCmd.length == 0) {
            return;
        }
        Quickshell.execDetached(settings.rightClickedCmd);
    }

    QtObject {
        id: internal

        function getDisplayModeFromString(value: string): int {
            // BUG: using Qt.enumStringToValue seems to cause crashes
            switch (value) {
            case "DisplayFull":
                return Battery.DisplayMode.DisplayFull;
            case "DisplayIcon":
                return Battery.DisplayMode.DisplayIcon;
            case "DisplayIconOnly":
                return Battery.DisplayMode.DisplayIconOnly;
            case "DisplayNone":
                return Battery.DisplayMode.DisplayNone;
            default:
                break;
            }
            return undefined;
        }
    }

    component BatteryLevelChip: Widgets.Chip {
        id: chip

        required property string model
        required property real battery
        required property int type
        required property bool isBluetoothDevice

        property color foreground: Config.Style.colors.base

        visible: {
            if (root.ignoreBluetoothDevices && isBluetoothDevice) {
                return false;
            }
            return type != UPowerDeviceType.LinePower && type != UPowerDeviceType.Battery;
        }

        height: root.height - root.padding * 2
        color: Utils.Display.batteryLevelBgColor(battery)

        content: Row {
            spacing: 4

            Widgets.Text {
                anchors.verticalCenter: parent.verticalCenter
                visible: root.displayMode == Battery.DisplayMode.DisplayFull
                text: chip.model
                color: chip.foreground
                font.pointSize: 10
            }
            Widgets.MaterialIcon {
                anchors.verticalCenter: parent.verticalCenter
                text: Utils.MaterialIcons.getUPowerDeviceIcon(chip.type)
                color: chip.foreground
                font.pointSize: 12
            }
            Widgets.Text {
                anchors.verticalCenter: parent.verticalCenter
                visible: root.displayMode == Battery.DisplayMode.DisplayFull || root.displayMode == Battery.DisplayMode.DisplayIcon
                text: Utils.Display.formatPercentage(chip.battery)
                color: chip.foreground
                font.pointSize: 10
            }
        }
    }

    content: Row {
        spacing: 4

        Widgets.MaterialIcon {
            id: icon
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 14
            text: root.charging ? Utils.MaterialIcons.getBatteryChargingIcon(root.chargeLevel) : Utils.MaterialIcons.getBatteryIcon(root.chargeLevel)
            color: root.foreground
        }

        Widgets.Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Utils.Display.formatPercentage(root.chargeLevel)
            color: root.foreground
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4
            visible: root.displayMode != Battery.DisplayMode.DisplayNone
            Repeater {
                model: root.devices
                delegate: BatteryLevelChip {
                    required property var modelData
                    model: modelData.model
                    battery: modelData.percentage
                    type: modelData.type
                    isBluetoothDevice: modelData.nativePath.startsWith("/org/bluez")
                }
            }
        }
    }
}
