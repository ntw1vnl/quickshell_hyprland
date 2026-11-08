pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking

import qs.config as Config
import qs.widgets as Widgets

import "root:/utils/Utils.js" as UtilsJS

Widgets.Chip {
    id: root

    enum DisplayMode {
        DisplayName,
        DisplayNone
    }

    padding: 4
    enableHover: true

    readonly property list<WiredDevice> devices: Networking.devices.values.filter(device => device.type === DeviceType.Wired)

    readonly property JsonObject settings: Config.Settings.modules.network
    property int displayMode: UtilsJS.enumStringToValue(WiredNetwork.DisplayMode, "WiredNetwork.DisplayMode", settings.displayMode, WiredNetwork.DisplayMode.DisplayNone)
    property bool onlyDisplayConnected: true
    property bool hideIfNoneConnected: true

    visible: hideIfNoneConnected ? hasConnectedDevice() : true

    function hasConnectedDevice(): bool {
        return devices.some(device => device.connected);
    }

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

    component WiredConnectionChip: Widgets.Chip {
        id: chip
        property string name
        property bool connected
        height: root.height - root.padding * 2
        bgColor: connected ? Config.Settings.colors.green : Config.Settings.colors.red
        content: Row {
            id: row
            spacing: 4

            Widgets.Text {
                id: text
                anchors.verticalCenter: parent.verticalCenter
                color: Config.Settings.colors.bgDark
                text: chip.name
                font.pointSize: 10
            }
        }
    }

    content: Row {
        spacing: 4

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            text: "lan"
            font.pointSize: 16
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4
            visible: root.displayMode != Bluetooth.DisplayMode.DisplayNone
            Repeater {
                model: root.devices
                delegate: WiredConnectionChip {
                    required property var modelData
                    name: modelData.network.name
                    connected: modelData.connected
                    visible: root.onlyDisplayConnected ? connected : true
                }
            }
        }
    }
}
