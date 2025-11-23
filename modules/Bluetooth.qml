pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Bluetooth as QSB

import "../config" as Config
import "../utils" as Utils
import "../widgets" as Widgets

Widgets.Chip {
    id: root

    enum DeviceDisplayMode {
        DisplayFull, // name + icon + battery level
        DisplayName, // name + icon
        DisplayBattery, // icon + battery
        DisplayIconOnly, // icon only
        DisplayNone // display nothing
    }

    enableHover: true

    readonly property var adapter: QSB.Bluetooth.defaultAdapter
    readonly property var devices: adapter?.devices
    readonly property var connectedDevices: devices?.values.filter(device => device.connected)
    readonly property int connectedDevicesCount: connectedDevices?.length ?? 0

    property bool displayBatteryLevelBg: true
    property int displayMode: Bluetooth.DeviceDisplayMode.DisplayIconOnly

    property var aliases: [
        {
            pattern: /.*WH-1000XM3/,
            alias: "Sony"
        },
        {
            pattern: /Stadia.*/,
            alias: "Stadia"
        }
    ]

    function getAlias(name) {
        for (const aliasPatterns of root.aliases) {
            const match = name.match(aliasPatterns.pattern);
            if (match) {
                return aliasPatterns.alias;
            }
        }
        return undefined;
    }

    component BluetoothDeviceChip: Widgets.Chip {
        id: chip
        height: root.height - root.padding * 2
        color: batteryAvailable && root.displayBatteryLevelBg ? Utils.Display.batteryLevelBgColor(battery) : Config.Style.colors.green

        required property string name
        required property string icon
        required property bool batteryAvailable
        required property real battery

        property color foreground: Config.Style.colors.base

        content: Row {
            id: adapterContentRow
            spacing: 4

            Widgets.Text {
                anchors.verticalCenter: parent.verticalCenter
                visible: root.displayMode == Bluetooth.DeviceDisplayMode.DisplayFull || root.displayMode == Bluetooth.DeviceDisplayMode.DisplayName
                color: chip.foreground
                text: chip.name
                font.pointSize: 10
            }
            Widgets.MaterialIcon {
                anchors.verticalCenter: parent.verticalCenter
                text: Utils.MaterialIcons.fromDesktopIconId(chip.icon)
                color: chip.foreground
                font.pointSize: 12
            }
            Widgets.Text {
                anchors.verticalCenter: parent.verticalCenter
                visible: chip.batteryAvailable && root.displayMode == Bluetooth.DeviceDisplayMode.DisplayFull || root.displayMode == Bluetooth.DeviceDisplayMode.DisplayBattery
                color: chip.foreground
                text: Utils.Display.formatPercentage(chip.battery)
                font.pointSize: 10
            }
        }
    }

    content: Row {
        spacing: 4

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 13
            text: {
                if (!root.adapter || !root.adapter.enabled) {
                    return "bluetooth_disabled";
                }
                if (root.connectedDevicesCount > 0) {
                    return "bluetooth_connected";
                }
                return "bluetooth";
            }
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4
            visible: root.displayMode != Bluetooth.DeviceDisplayMode.DisplayNone
            Repeater {
                model: root.connectedDevices
                delegate: BluetoothDeviceChip {
                    required property var modelData
                    name: root.getAlias(modelData.name) ?? modelData.name
                    icon: modelData.icon
                    batteryAvailable: modelData.batteryAvailable
                    battery: modelData.battery
                }
            }
        }
    }
}
