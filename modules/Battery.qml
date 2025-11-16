pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.UPower

import "../config" as Config
import "../utils" as Utils
import "../widgets" as Widgets

Widgets.Chip {
    id: root

    enum DeviceDisplayMode {
        DisplayFull, // name + icon + level
        DisplayIcon, // icon + level
        DisplayIconOnly, // icon
        DisplayNone
    }

    readonly property var displayDevice: UPower.displayDevice
    readonly property var devices: UPower.devices
    readonly property bool charging: root.displayDevice.state == UPowerDeviceState.Charging
    readonly property real chargeLevel: root.displayDevice.percentage

    property int deviceDisplayMode: Battery.DeviceDisplayMode.DisplayIcon
    property bool ignoreBluetoothDevices: true
    property color foreground: charging ? Config.Style.colors.green : Utils.Display.batteryLevelTextColor(chargeLevel)

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
                visible: root.deviceDisplayMode == Battery.DeviceDisplayMode.DisplayFull
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
                visible: root.deviceDisplayMode == Battery.DeviceDisplayMode.DisplayFull || root.deviceDisplayMode == Battery.DeviceDisplayMode.DisplayIcon
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
            visible: root.deviceDisplayMode != Battery.DeviceDisplayMode.DisplayNone
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
