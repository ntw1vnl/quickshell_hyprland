import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.modules as Modules

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 32

    // color: "transparent"

    property real margins: 4

    Modules.WorkspacesWidget {
        anchors.left: parent.left
        anchors.leftMargin: root.margins
        anchors.verticalCenter: parent.verticalCenter
    }
}
