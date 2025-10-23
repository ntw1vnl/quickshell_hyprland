import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
            // delegate: Components.WorkspaceButton { }
        }
    }

    Rectangle {
      id: bg
      anchors.fill: parent
      z: layout.z - 1
      color: "red"
      opacity: 0.6
      radius: height / 2
    }

    Component {
        id: workspaceButtonComp

        Rectangle {
            property real implicitSize: root.delegateSize
            Layout.alignment: Qt.AlignVCenter
            implicitHeight: implicitSize
            implicitWidth: implicitSize
            // implicitWidth: modelData.active ? 2 * implicitSize : implicitSize
            radius: height / 2
            color: modelData.active ? "black" : "white"
            // color: ""

            Text {
                anchors.centerIn: parent
                text: modelData.id
                color: modelData.active ? "white" : "black"

            }
        }
    }

}
