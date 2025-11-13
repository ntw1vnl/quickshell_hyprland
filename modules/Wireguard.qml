pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets

import qs.config as Config
import qs.widgets as Widgets
import qs.services as Services

Widgets.Chip {
    id: root

    enum DisplayMode {
        Full, // full name + icon
        Short, // short name + icon
        IconOnly, // icon only
        None // do not display vpn info
    }

    padding: 4

    property int vpnDisplayMode: Wireguard.DisplayMode.Short
    property int shortDisplayModeCharacterCount: 2
    property bool displayAllConnectedVpnConnections: false

    component WireguardConnectionChip: Widgets.Chip {
        id: chip
        property string name
        height: root.height - root.padding * 2
        color: Config.Style.colors.green
        content: Row {
            id: row
            spacing: 4

            Widgets.Text {
                id: text
                anchors.verticalCenter: parent.verticalCenter
                color: Config.Style.colors.base
                // text: "🇩🇪"
                text: {
                    if (root.vpnDisplayMode == Wireguard.DisplayMode.Short && chip.name.length > root.shortDisplayModeCharacterCount) {
                        return chip.name.substring(0, root.shortDisplayModeCharacterCount);
                    }
                    return chip.name;
                }
                font.pointSize: 10
                visible: root.vpnDisplayMode == Wireguard.DisplayMode.Full || 
                         root.vpnDisplayMode == Wireguard.DisplayMode.Short
            }

            // Widgets.MaterialIcon {
            //     anchors.verticalCenter: parent.verticalCenter
            //     text: "shield"
            //     color: text.color
            //     font.pointSize: 12
            //     font.bold: true
            // }
        }
    }

    content: Row {
        spacing: 4

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            text: "shield" 
            font.pointSize: 16
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4
            visible: root.vpnDisplayMode != Wireguard.DisplayMode.None
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
