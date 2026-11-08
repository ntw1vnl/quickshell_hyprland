pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import "../config" as Config
import "../utils" as Utils
import "../utils/Utils.js" as UtilsJS
import "../widgets" as Widgets
import "../services" as Services

Widgets.Chip {
    id: root

    enum DisplayMode {
        DisplayProfileNotIdentity,
        DisplayAlways
    }

    readonly property JsonObject settings: Config.Settings.modules.nightLight
    property int displayMode: UtilsJS.enumStringToValue(NightLight.DisplayMode, "NightLight.DisplayMode", settings.displayMode, NightLight.DisplayMode.DisplayProfileNotIdentity)

    visible: {
        switch (displayMode) {
        case NightLight.DisplayMode.DisplayAlways:
            return true;
        case NightLight.DisplayMode.DisplayProfileNotIdentity:
            return !Services.NightLightService.isIdentityProfile;
        }
    }

    enableHover: true

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
    }

    content: Row {
        spacing: 4

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 16
            text: "dark_mode"
            color: Config.Settings.colors.red
        }
    }
}
