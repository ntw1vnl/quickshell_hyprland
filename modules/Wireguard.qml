pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import "../config" as Config
import "../services" as Services
import "../widgets" as Widgets

Widgets.Chip {
    id: root

    enum DisplayMode {
        DisplayFullName, // full name
        DisplayShortName, // short name
        DisplayNone // do not display vpn info
    }

    readonly property JsonObject settings: Config.Settings.modules.wireguard
    property int vpnDisplayMode: internal.getDisplayModeFromString(settings.displayMode) ?? Wireguard.DisplayShortName
    property int shortDisplayModeCharacterCount: settings.shortDisplayModeCharacterCount
    property bool displayAllConnectedVpnConnections: false

    padding: 4
    visible: Services.NetworkManager.activeWireguardConnections.length > 0

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
            case "DisplayFullName":
                return Wireguard.DisplayFullName;
            case "DisplayShortName":
                return Wireguard.DisplayShortName;
            case "DisplayNone":
                return Wireguard.DisplayNone;
            }
            return undefined;
        }
    }

    component WireguardConnectionChip: Widgets.Chip {
        id: chip
        property string name
        height: root.height - root.padding * 2
        color: Config.Style.colors.green

        onRightClicked: {
            Quickshell.execDetached(["nmcli", "connection", "down", name]);
            Quickshell.execDetached(["nmcli", "connection", "up", name]);
            Quickshell.execDetached(["notify-send", `Wireguard connection ${name} reset`]);
        }

        content: Row {
            id: row
            spacing: 4

            Widgets.Text {
                id: text
                anchors.verticalCenter: parent.verticalCenter
                color: Config.Style.colors.base
                text: {
                    if (root.vpnDisplayMode == Wireguard.DisplayShortName && chip.name.length > root.shortDisplayModeCharacterCount) {
                        return chip.name.substring(0, root.shortDisplayModeCharacterCount);
                    }
                    return chip.name;
                }
                font.pointSize: 10
                visible: root.vpnDisplayMode == Wireguard.DisplayFullName || root.vpnDisplayMode == Wireguard.DisplayShortName
            }
        }
    }

    content: Row {
        spacing: 4

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            text: "vpn_lock_2"
            font.pointSize: 16
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4
            visible: root.vpnDisplayMode != Wireguard.DisplayNone
            Repeater {
                model: Services.NetworkManager.activeWireguardConnections
                delegate: WireguardConnectionChip {
                    required property int index
                    required property var modelData
                    name: modelData.name
                    visible: root.displayAllConnectedVpnConnections ? true : index == 0
                }
            }
        }
    }
}
