pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import QtQuick

import "../widgets" as Widgets
import "../config" as Config

Widgets.Chip {
    id: root

    property real delegateSize: height - padding * 2

    component WorkspaceButton: Widgets.Chip {
        id: workspaceButton
        required property int index
        required property var identifier
        required property bool active
        bgColor: active ? Config.Settings.colors.accent : Config.Settings.colors.bgLight
        implicitHeight: root.delegateSize
        implicitWidth: root.delegateSize

        HoverHandler {
            id: hoverHandler
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            id: tapHandler
            onTapped: {
                if (!workspaceButton.active)
                    Hyprland.workspaces.values[workspaceButton.index].activate();
            }
        }

        Widgets.Text {
            anchors.centerIn: parent
            text: workspaceButton.identifier
            highlight: workspaceButton.active
            highlightColor: Config.Settings.colors.bg
        }
    }

    content: Row {
        id: layout
        spacing: root.padding
        Repeater {
            model: Hyprland.workspaces
            delegate: WorkspaceButton {
                required property var modelData
                active: modelData.active
                identifier: modelData.id
            }
        }
    }
}
