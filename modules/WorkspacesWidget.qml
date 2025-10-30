import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import qs.widgets as Widgets
import qs.config as Config

Item {
    id: root

    property real itemHeight: 28

    property real padding: 4
    property real delegateSize: itemHeight - padding * 2

    implicitHeight: itemHeight
    implicitWidth: layout.implicitWidth + padding * 2

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: root.padding
        Repeater {
            model: Hyprland.workspaces
            delegate: workspaceButtonComp
        }
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        z: layout.z - 1
        color: Config.Style.colors.surface0
        radius: height / 2
    }

    Component {
        id: workspaceButtonComp

        Rectangle {
            required property int index
            required property var modelData
            readonly property real implicitSize: root.delegateSize
            readonly property color bgColor: modelData.active ? Config.Style.accentColor : Config.Style.colors.overlay0

            Layout.alignment: Qt.AlignVCenter
            implicitHeight: implicitSize
            implicitWidth: implicitSize
            radius: height / 2
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
    }
}
