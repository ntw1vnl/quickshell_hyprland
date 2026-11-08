import QtQuick
import Quickshell

import qs.config as Config
import qs.bar.modules as Modules
import qs.utils as Utils
import qs.widgets as Widgets

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 32
    color: "transparent"
    // color: Config.Settings.theme.palette.bg
    aboveWindows: false

    property real margins: 4

    Component.onCompleted: {
        Utils.Globals.bar = root;
        Utils.Globals.centerSwitchable = centerSwitchableModule;
    }

    Row {
        anchors.left: parent.left
        anchors.leftMargin: root.margins
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4
        Modules.Workspaces {}
        Modules.Mpris {}
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4
        Widgets.Switchable {
            id: centerSwitchableModule
            items: [
                Modules.Clock {},
                Modules.Weather {},
                Modules.WindowInfo {}
            ]
        }
    }

    Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: root.margins
        spacing: 4
        Modules.NightLight {}
        Modules.Updates {}
        Modules.Volume {}
        Modules.Bluetooth {}
        Modules.Wifi {}
        Modules.WiredNetwork {}
        Modules.Wireguard {}
        Modules.SystemTray {}
        Modules.Battery {}
    }
}
