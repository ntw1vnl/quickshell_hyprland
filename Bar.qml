import QtQuick
import Quickshell

import "modules" as Modules

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 32

    color: "transparent"

    property real margins: 4

    Row {
        anchors.left: parent.left
        anchors.leftMargin: root.margins
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4
        Modules.Workspaces {}
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4
        Modules.Clock {}
    }

    Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: root.margins
        spacing: 4
        Modules.Volume {}
        Modules.Bluetooth {}
        Modules.Network {}
        Modules.Wireguard {}
        Modules.SystemTray {}
        Modules.Battery {}
    }
}
