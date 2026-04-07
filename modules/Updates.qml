pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import "../config" as Config
import "../services" as Services
import "../widgets" as Widgets

Widgets.Chip {
    id: root

    //TODO: Add DisplayMode enum for more configuration options

    enum Status {
        Normal,
        Warning,
        Critical
    }

    readonly property JsonObject settings: Config.Settings.modules.updates

    rightPadding: 8
    visible: Services.UpdateHandler.kernelUpdateAvailable || Services.UpdateHandler.totalUpdatesCount > settings.minTreshold

    onLeftClicked: {
        if (!settings.leftClickedCmd || settings.leftClickedCmd.length == 0) {
            return;
        }
        Quickshell.execDetached(settings.leftClickedCmd);
    }

    QtObject {
        id: internal

        readonly property int status: {
            if (Services.UpdateHandler.totalUpdatesCount > settings.criticalTreshold &&
                settings.criticalTreshold !== -1) {
                return Updates.Status.Critical;
            }
            if (Services.UpdateHandler.totalUpdatesCount > settings.warningTreshold &&
                settings.warningTreshold !== -1) {
                return Updates.Status.Warning;
            }
            return Updates.Status.Normal;
        }

        readonly property color color: {
            switch (internal.status) {
            case Updates.Status.Normal:
                return Config.Settings.colors.text;
            case Updates.Status.Warning:
                return Config.Settings.colors.yellow;
            case Updates.Status.Critical:
                return Config.Settings.colors.red;
            }
        }
    }

    content: Row {
        spacing: 4

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            text: "refresh"
            font.pointSize: 16
            font.bold: false
            color: internal.color
        }

        Widgets.Text {
            text: Services.UpdateHandler.totalUpdatesCount
            anchors.verticalCenter: parent.verticalCenter
            color: internal.color
        }

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            text: "token"
            visible: Services.UpdateHandler.kernelUpdateAvailable
            font.pointSize: 16
            color: internal.color
        }
    }
}
