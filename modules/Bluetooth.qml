pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth

import qs.config as Config
import qs.utils as Utils
import qs.widgets as Widgets

Widgets.Chip {
    id: root

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var devices: adapter?.devices
    readonly property var connectedDevices: devices?.values.filter(device => device.connected)
    readonly property int connectedDevicesCount: connectedDevices?.length ?? 0

    component BluetoothDeviceChip: Widgets.Chip {
        id: chip
        height: root.height - root.padding * 2
        color: Config.Style.colors.green
        required property string name
        required property string icon
        content: Row {
            id: adapterContentRow
            anchors.centerIn: parent
            spacing: 4
            Widgets.Text {
                id: text
                anchors.verticalCenter: parent.verticalCenter
                color: Config.Style.colors.base
                text: chip.name
                font.pointSize: 10
            }
            Widgets.MaterialIcon {
                anchors.verticalCenter: parent.verticalCenter
                text: Utils.MaterialIcons.fromDesktopIconId(chip.icon)
                color: text.color
                font.pointSize: 12
            }
        }
    }

    content: Row {

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 14
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
            Repeater {
                model: root.connectedDevices
                delegate: BluetoothDeviceChip {
                    required property var modelData
                    name: modelData.name
                    icon: modelData.icon
                }
            }
        }
    }
}
