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
        DisplayName,
        DisplayNone
    }

    padding: 4
    enableHover: true

    readonly property JsonObject settings: Config.Settings.modules.network
    readonly property int defaultDisplayMode: Network.DisplayMode.DisplayNone
    property int displayMode: internal.getDisplayModeFromString(settings.displayMode) ?? defaultDisplayMode

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
            case "DisplayName":
                return Network.DisplayName;
            case "DisplayNone":
                return Network.DisplayNone;
            }
            return undefined;
        }
    }

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
