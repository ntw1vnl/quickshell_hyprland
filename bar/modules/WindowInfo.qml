pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Hyprland

import qs.widgets as Widgets

Widgets.Chip {
    id: root

    leftPadding: 16
    rightPadding: 16
    enableHover: true

    visible: activeToplevelOnCurrentWorkspace

    property string activeToplevelTitle: Hyprland.activeToplevel?.title ?? ""
    property bool activeToplevelOnCurrentWorkspace: Hyprland.activeToplevel?.workspace == Hyprland.focusedWorkspace

    Connections {
        target: Hyprland
        function onActiveToplevelChanged() {
            const topLevel = Hyprland.activeToplevel;
            const topLevelWorkspace = topLevel.workspace;
        }
    }

    content: Row {
        spacing: 4
        Widgets.Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.activeToplevelOnCurrentWorkspace ? root.activeToplevelTitle : ""
            font.pointSize: 10
        }
    }
}
