import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.modules as Modules

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 32

    // surfaceFormat.opaque: false 
    // color: "transparent"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4

        Modules.WorkspacesWidget {}
    }
}
