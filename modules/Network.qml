pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets

import qs.config as Config
import qs.widgets as Widgets
import qs.services as Services

Widgets.Chip {
    id: root

    padding: 4

    component WifiConnectionChip: Widgets.Chip {
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
                text: chip.name
                font.pointSize: 10
            }
        }
    }

    content: Row {
        spacing: 4

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            text: Services.NetworkManager.icon
            font.pointSize: 16
        }

        WifiConnectionChip {
            anchors.verticalCenter: parent.verticalCenter
            name: Services.NetworkManager.wifi.networkName
            visible: Services.NetworkManager.wifi.status == Services.NetworkManager.WifiStatus.Connected || 
                     Services.NetworkManager.wifi.status == Services.NetworkManager.WifiStatus.Connecting 
        }
    }
}
