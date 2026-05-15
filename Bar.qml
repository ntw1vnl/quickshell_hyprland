import QtQuick
import Quickshell

import "modules" as Modules
import "utils" as Utils
import "widgets" as Widgets

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 32
    color: "transparent"
    aboveWindows: false

    property real margins: 4

    Component.onCompleted: {
        Utils.Globals.bar = root;
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
            items: [
                Modules.Clock {},
                Modules.Weather {}
            ]
        }
    }

    Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: root.margins
        spacing: 4
        Modules.Updates {}
        Modules.Volume {}
        Modules.Bluetooth {}
        Modules.Network {}
        Modules.Wireguard {}
        Modules.SystemTray {}
        Modules.Battery {}
    }
}
