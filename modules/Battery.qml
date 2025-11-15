pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.UPower

import qs.config as Config
import qs.utils as Utils
import qs.widgets as Widgets

Widgets.Chip {
    id: root

    property real batteryRedTreshold: 0.10
    property real batteryOrangeTreshold: 0.25

    readonly property var displayDevice: UPower.displayDevice
    readonly property var devices: UPower.devices

    readonly property bool charging: root.displayDevice.state
                                     == UPowerDeviceState.Charging
    readonly property real chargeLevel: root.displayDevice.percentage

    component BatteryLevelChip: Widgets.Chip {
        id: chip

        required property string model
        required property real percentage
        required property int type

        visible: type != UPowerDeviceType.LinePower && type
                 != UPowerDeviceType.Battery
        height: root.height - root.padding * 2
        // color: Config.Style.colors.green
        color: {
            if (percentage <= root.batteryRedTreshold) {
                return Config.Style.colors.red;
            } else if (percentage <= root.batteryOrangeTreshold) {
                return Config.Style.colors.peach;
            }
            return Config.Style.colors.green;
        }

        content: Row {
            spacing: 4
            Widgets.Text {
                id: text
                anchors.verticalCenter: parent.verticalCenter
                text: `${Math.round(chip.percentage * 100)} %`
                color: Config.Style.colors.base
                font.pointSize: 10
            }
            Widgets.MaterialIcon {
                anchors.verticalCenter: parent.verticalCenter
                text: Utils.MaterialIcons.getUPowerDeviceIcon(chip.type)
                color: text.color
                font.pointSize: 12
            }
        }
    }

    QtObject {
        id: internal

        function getBatteryColor(level, charging) {
            if (charging) {
                return Config.Style.colors.green;
            }
            if (level <= root.batteryRedTreshold) {
                return Config.Style.colors.red;
            }
            if (level <= root.batteryOrangeTreshold) {
                return Config.Style.colors.peach;
            }
            return Config.Style.colors.text;
        }
    }

    content: Row {
        spacing: 4

        Widgets.MaterialIcon {
            id: icon
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 14
            text: root.charging ? Utils.MaterialIcons.getBatteryChargingIcon(
                                      root.chargeLevel) :
                                  Utils.MaterialIcons.getBatteryIcon(
                                      root.chargeLevel)
            color: internal.getBatteryColor(root.chargeLevel, root.charging)
        }

        Widgets.Text {
            anchors.verticalCenter: parent.verticalCenter
            text: `${Math.round(root.chargeLevel * 100 ?? 0)} %`
            color: icon.color
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4
            Repeater {
                model: root.devices
                delegate: BatteryLevelChip {
                    required property var modelData
                    model: modelData.model
                    percentage: modelData.percentage
                    type: modelData.type
                }
            }
        }
    }
}
