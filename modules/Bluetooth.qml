pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Bluetooth as QSB
import Quickshell.Io

import "../config" as Config
import "../utils" as Utils
import "../widgets" as Widgets

Widgets.Chip {
    id: root

    enum DisplayMode {
        DisplayFull, // name + icon + battery level
        DisplayName, // name + icon
        DisplayBattery, // icon + battery
        DisplayIconOnly, // icon only
        DisplayNone // display nothing
    }

    readonly property JsonObject settings: Config.Settings.modules.bluetooth
    readonly property QSB.BluetoothAdapter defaultAdapter: QSB.Bluetooth.defaultAdapter
    readonly property var devices: defaultAdapter?.devices
    readonly property var connectedDevices: devices?.values.filter(device => device.connected)
    readonly property int connectedDevicesCount: connectedDevices?.length ?? 0
    readonly property int defaultDisplayMode: Bluetooth.DisplayMode.DisplayFull
    property int displayMode: internal.getDisplayModeFromString(settings.displayMode) ?? defaultDisplayMode
    property bool displayBatteryLevelBg: settings.batteryLevelAsBackground
    property var aliases: settings.deviceAliases

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

        function getAlias(name) {
            for (const aliasPattern of root.aliases) {
                const regex = new RegExp(aliasPattern.pattern);
                const match = name.match(regex);
                if (match) {
                    return aliasPattern.alias;
                }
            }
            return undefined;
        }

        function getDisplayModeFromString(value: string): int {
            // BUG: using Qt.enumStringToValue seems to cause crashes
            switch (value) {
            case "DisplayFull":
                return Bluetooth.DisplayMode.DisplayFull;
            case "DisplayName":
                return Bluetooth.DisplayMode.DisplayName;
            case "DisplayBattery":
                return Bluetooth.DisplayMode.DisplayBattery;
            case "DisplayIconOnly":
                return Bluetooth.DisplayMode.DisplayIconOnly;
            case "DisplayNone":
                return Bluetooth.DisplayMode.DisplayNone;
            default:
                break;
            }
            return undefined;
        }
    }

    component BluetoothDeviceChip: Widgets.Chip {
        id: chip
        height: root.height - root.padding * 2
        bgColor: batteryAvailable && root.displayBatteryLevelBg ? Utils.Display.batteryLevelBgColor(battery) : Config.Settings.colors.green

        required property string name
        required property string icon
        required property bool batteryAvailable
        required property real battery

        property color foreground: Config.Settings.colors.bgDark

        content: Row {
            id: adapterContentRow
            spacing: 4

            Widgets.Text {
                anchors.verticalCenter: parent.verticalCenter
                visible: root.displayMode == Bluetooth.DisplayMode.DisplayFull || root.displayMode == Bluetooth.DisplayMode.DisplayName
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
                visible: chip.batteryAvailable && (root.displayMode == Bluetooth.DisplayMode.DisplayFull || root.displayMode == Bluetooth.DisplayMode.DisplayBattery)
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
                if (!root.defaultAdapter || !root.defaultAdapter.enabled) {
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
            visible: root.displayMode != Bluetooth.DisplayMode.DisplayNone
            Repeater {
                model: root.connectedDevices
                delegate: BluetoothDeviceChip {
                    required property var modelData
                    name: internal.getAlias(modelData.name) ?? modelData.name
                    icon: modelData.icon
                    batteryAvailable: modelData.batteryAvailable
                    battery: modelData.battery
                }
            }
        }
    }
}
