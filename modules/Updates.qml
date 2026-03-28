pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import "../config" as Config
import "../services" as Services
import "../widgets" as Widgets

Widgets.Chip {
    id: root

    readonly property JsonObject settings: Config.Settings.modules.updates

    rightPadding: 8
    visible: Services.UpdateHandler.kernelUpdateAvailable || Services.UpdateHandler.totalUpdatesCount > settings.minTreshold

    onLeftClicked: {
        if (!settings.leftClickedCmd || settings.leftClickedCmd.length == 0) {
            return;
        }
        Quickshell.execDetached(settings.leftClickedCmd);
    }

    content: Row {
        spacing: 4

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            text: "refresh"
            font.pointSize: 16
            font.bold: false
        }

        Widgets.Text {
            text: Services.UpdateHandler.totalUpdatesCount
            anchors.verticalCenter: parent.verticalCenter
        }

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            text: "token"
            visible: Services.UpdateHandler.kernelUpdateAvailable
            font.pointSize: 16
        }
    }
}
