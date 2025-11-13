import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import qs.widgets as Widgets
import qs.config as Config

Widgets.Chip {
    id: root

    property real delegateSize: height - padding * 2

    component WorkspaceButton : Widgets.Chip {
        required property bool active
        readonly property color bgColor: active ? Config.Style.accentColor : Config.Style.colors.overlay0
        implicitHeight: root.delegateSize
        implicitWidth: root.delegateSize
        color: hoverHandler.hovered ? Qt.lighter(bgColor, 1.2) : bgColor

        HoverHandler {
            id: hoverHandler
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            id: tapHandler
            onTapped: {
                if (!modelData.active)
                    Hyprland.workspaces.values[index].activate();
            }
        }

        Widgets.Text {
            anchors.centerIn: parent
            text: modelData.id
            highlight: modelData.active
            highlightColor: "black"
        }
    }

    content: Row {
        id: layout
        spacing: root.padding
        Repeater {
            model: Hyprland.workspaces
            delegate: WorkspaceButton {
                required property int index
                required property var modelData
                active: modelData.active
            }
        }
    }
}
