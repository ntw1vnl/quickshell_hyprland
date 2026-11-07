pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking

import "../config" as Config
import "../utils" as Utils
import "../utils/Utils.js" as UtilsJS
import "../widgets" as Widgets

Widgets.Chip {
    id: root

    enum DisplayMode {
        DisplayName,
        DisplayNone
    }

    enum DisplayNameStyle {
        DisplayNameText,
        DisplayNameChip
    }

    padding: 4
    enableHover: true

    readonly property JsonObject settings: Config.Settings.modules.wifi
    readonly property WifiDevice device: Networking.devices.values.find(device => device.type === DeviceType.Wifi) ?? null
    readonly property WifiNetwork network: device?.networks.values.find(network => network.connected == true) ?? null
    property int displayMode: UtilsJS.enumStringToValue(Wifi.DisplayMode, "Wifi.DisplayMode", settings.displayMode, Wifi.DisplayMode.DisplayNone)
    property int displayNameStyle: UtilsJS.enumStringToValue(Wifi.DisplayNameStyle, "Wifi.DisplayNameStyle", settings.displayNameStyle, Wifi.DisplayNameStyle.DisplayNameText)

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

    Component {
        id: wifiNameChip
        Widgets.Chip {
            height: root.height - root.padding * 2
            bgColor: Config.Settings.colors.green
            content: Row {
                id: row
                spacing: 4

                Widgets.Text {
                    id: text
                    anchors.verticalCenter: parent.verticalCenter
                    color: Config.Settings.colors.bgDark
                    text: root.network?.name ?? ""
                    font.pointSize: 10
                }
            }
        }
    }

    Component {
        id: wifiNameText
        Widgets.Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.network?.name ?? ""
            visible: root.displayMode != Wifi.DisplayMode.DisplayNone && root.network && (root.network.connected || root.network.state == ConnectionState.Connecting)
        }
    }

    content: Row {
        spacing: 4

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            text: {
                if (!root.device) {
                    return "signal_wifi_off";
                }
                switch (root.device.state) {
                case ConnectionState.Connecting:
                case ConnectionState.Connected:
                    return Utils.MaterialIcons.getWifiConnectedIcon(root.network.signalStrength);
                case ConnectionState.Disconnected:
                case ConnectionState.Disconnecting:
                    return "signal_wifi_statusbar_not_connected";
                case ConnectionState.Unknown:
                    return "signal_wifi_off";
                }
            }
            font.pointSize: 16
        }

        Loader {
            anchors.verticalCenter: parent.verticalCenter
            width: item ? item.implicitWidth : 0
            sourceComponent: {
                if (root.displayMode != Wifi.DisplayMode.DisplayName) {
                    return undefined;
                }
                switch (root.displayNameStyle) {
                case Wifi.DisplayNameStyle.DisplayNameChip:
                    return wifiNameChip;
                case Wifi.DisplayNameStyle.DisplayNameText:
                    return wifiNameText;
                }
            }
        }
    }
}
