pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import "../config" as Config
import "../services" as Services
import "../utils/Utils.js" as UtilsJS
import "../widgets" as Widgets

Widgets.Chip {
    id: root

    enum DisplayMode {
        DisplayName,
        DisplayNone
    }

    padding: 4
    enableHover: true

    readonly property JsonObject settings: Config.Settings.modules.network
    property int displayMode: UtilsJS.enumStringToValue(Network.DisplayMode, "Network.DisplayMode", settings.displayMode, Network.DisplayMode.DisplayNone)

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

    component WifiConnectionChip: Widgets.Chip {
        id: chip
        property string name
        height: root.height - root.padding * 2
        bgColor: Config.Settings.colors.green
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
            text: Services.NetworkManager.icon
            font.pointSize: 16
        }

        WifiConnectionChip {
            anchors.verticalCenter: parent.verticalCenter
            name: Services.NetworkManager.wifi.networkName
            visible: root.displayMode != Network.DisplayMode.DisplayNone && (Services.NetworkManager.wifi.status == Services.NetworkManager.WifiStatus.Connected || Services.NetworkManager.wifi.status == Services.NetworkManager.WifiStatus.Connecting)
        }
    }
}
