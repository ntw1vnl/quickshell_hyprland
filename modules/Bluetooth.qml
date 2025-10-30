pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth

import qs.config as Config
import qs.utils as Utils
import qs.widgets as Widgets

Item {
    id: root

    property real padding: 4

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var devices: adapter?.devices
    readonly property var connectedDevices: devices?.values.filter(device => device.connected)
    readonly property int connectedDevicesCount: connectedDevices?.length ?? 0

    implicitHeight: 28
    implicitWidth: contentRow.implicitWidth + padding * 2

    Row {
        id: contentRow
        anchors.centerIn: parent

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
                delegate: Rectangle {
                    id: adapterItem
                    required property var modelData
                    property real padding: 8
                    implicitHeight: adapterContentRow.implicitHeight
                    implicitWidth: adapterContentRow.implicitWidth + padding * 2
                    radius: height / 2
                    color: Config.Style.colors.green
                    Row {
                        id: adapterContentRow
                        anchors.centerIn: parent
                        spacing: 4
                        Widgets.Text {
                            id: text
                            anchors.verticalCenter: parent.verticalCenter
                            color: Config.Style.colors.base
                            text: adapterItem.modelData.name
                            font.pointSize: 10
                        }
                        Widgets.MaterialIcon {
                            anchors.verticalCenter: parent.verticalCenter
                            text: Utils.MaterialIcons.fromDesktopIconId(adapterItem.modelData.icon)
                            color: text.color
                            font.pointSize: 12
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        z: contentRow.z - 1
        color: Config.Style.colors.surface0
        radius: height / 2
    }
}
