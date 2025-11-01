import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.modules as Modules
import qs.config as Config
import qs.popups as Popups

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 32

    // color: "transparent"
    color: Config.Style.colors.base

    property real margins: 4

    Modules.WorkspacesWidget {
        anchors.left: parent.left
        anchors.leftMargin: root.margins
        anchors.verticalCenter: parent.verticalCenter
    }

    Modules.Clock {
        id: clock
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Popups.AllControlsPopup {
        id: popup
        anchorItem: clock
        visible: false
        // visible: true
    }

    Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: root.margins
        spacing: 4
        Modules.Volume {}
        Modules.Bluetooth {}
    }
}
