pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import QtQuick

import qs.widgets as Widgets
import qs.config as Config

Widgets.Chip {
    id: root

    property real delegateSize: height - padding * 2
    enableHover: false

    component WorkspaceButton: Widgets.Chip {
        id: workspaceButton
        required property int index
        required property string name
        required property var identifier
        required property bool active
        required property bool focused
        required property bool urgent

        property color defaultBgColor: Config.Settings.colors.bgLight
        property color activeBgColor: Config.Settings.colors.accent

        bgColor: active ? activeBgColor : defaultBgColor

        SequentialAnimation {
            id: urgentAnimation
            loops: Animation.Infinite
            property int duration: 700
            running: workspaceButton.urgent
            ColorAnimation {
                target: workspaceButton
                property: "bgColor"
                from: workspaceButton.defaultBgColor
                to: workspaceButton.activeBgColor
                duration: urgentAnimation.duration
            }
            PauseAnimation {
                duration: urgentAnimation.duration / 2
            }
            ColorAnimation {
                target: workspaceButton
                property: "bgColor"
                from: workspaceButton.activeBgColor
                to: workspaceButton.defaultBgColor
                duration: urgentAnimation.duration
            }
        }

        implicitHeight: root.delegateSize
        implicitWidth: root.delegateSize

        HoverHandler {
            id: hoverHandler
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            id: tapHandler
            onTapped: {
                if (!workspaceButton.active) {
                    Hyprland.workspaces.values[workspaceButton.index].activate();
                }
            }
        }

        Widgets.Text {
            id: text
            anchors.centerIn: parent
            text: (workspaceButton.identifier == "-1" ? "S" : workspaceButton.identifier)// + (workspaceButton.urgent ? " !" : "")
            highlight: workspaceButton.focused || workspaceButton.urgent
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
                name: modelData.name
                identifier: modelData.id
                focused: modelData.focused
                urgent: modelData.urgent
            }
        }
    }
}
