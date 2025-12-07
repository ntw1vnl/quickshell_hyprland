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
        DisplayAll, //Display all available wireguard connections
        DisplayPreferred //Only display wireguard connections defined in "preferredConnections" array
    }

    readonly property JsonObject settings: Config.Settings.modules.wireguard
    property int displayMode: internal.getDisplayModeFromString(settings.displayMode) ?? Wireguard.DisplayAll
    property string displayPattern: settings.displayPattern
    property bool displayOnlyActiveConnections: settings.displayOnlyActiveConnections
    property var wireguardConnections: Services.NetworkManager.wireguardConnections
    property var preferredConnections: settings.preferredConnections

    padding: 4
    visible: wireguardConnections.length > 0

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
            case "DisplayAll":
                return Wireguard.DisplayMode.DisplayAll;
            case "DisplayPreferred":
                return Wireguard.DisplayMode.DisplayPreferred;
            }
            return undefined;
        }
    }

    component WireguardConnectionChip: Widgets.Chip {
        id: chip
        property string name
        property bool active
        readonly property bool isPreferredConnection: root.preferredConnections?.includes(name) ?? false
        height: root.height - root.padding * 2
        visible: {
            if (root.displayMode == Wireguard.DisplayMode.DisplayPreferred && !isPreferredConnection) {
                return false;
            }
            if (root.displayOnlyActiveConnections) {
                return active;
            }
            return true;
        }

        bgColor: active ? Config.Settings.colors.green : Config.Settings.colors.red

        onLeftClicked: {
            if (active) {
                Quickshell.execDetached(["nmcli", "connection", "down", name]);
            } else {
                Quickshell.execDetached(["nmcli", "connection", "up", name]);
            }
        }

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
                color: Config.Settings.colors.bgDark
                font.pointSize: 10
                text: {
                    if (!root.displayPattern) {
                        return chip.name;
                    }
                    const regex = new RegExp(root.displayPattern);
                    const matches = chip.name.match(regex);
                    if (!matches) {
                        console.warning(`no matches found for pattern`);
                        return chip.name;
                    }
                    if (matches.length > 1) {
                        console.warning(`Wireguard displayPattern returned ${matches.length} matches for displayPattern "${root.displayPattern}", using first match`);
                    }
                    return matches[0];
                }
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
            id: connectionsRow
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4
            Repeater {
                model: root.wireguardConnections
                delegate: WireguardConnectionChip {
                    required property int index
                    required property var modelData
                    name: modelData.name
                    active: modelData.active
                }
            }
        }
    }
}
