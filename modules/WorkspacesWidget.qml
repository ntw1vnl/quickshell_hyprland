import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.widgets as Widgets
import qs.style as Style

Item {
    id: root

    property real padding: 4
    property real delegateSize: 20

    implicitHeight: delegateSize + padding * 2
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
      color: Style.Colors.base
      radius: height / 2
    }

    Component {
        id: workspaceButtonComp

        Rectangle {
            property real implicitSize: root.delegateSize
            Layout.alignment: Qt.AlignVCenter
            implicitHeight: implicitSize
            implicitWidth: implicitSize
            radius: height / 2
            color: modelData.active ? Style.Colors.maroon : Style.Colors.overlay0

            Widgets.Text {
                anchors.centerIn: parent
                text: modelData.id
                highlight: modelData.active
                highlightColor: "black"
            }
        }
    }

}
