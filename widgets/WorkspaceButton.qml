import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material.impl

AbstractButton {
    id: root

    readonly property real radius: background.height/2

    property bool isActiveWorkspace: false

    background: Rectangle {
        // implicitWidth: root.isActiveWorkspace ? root.Material.buttonHeight * 2 : root.Material.buttonHeight
        implicitWidth: root.Material.buttonHeight
        implicitHeight: root.Material.buttonHeight

        radius: root.radius
        color: "blue"
        // color: root.Material.buttonColor(root.Material.theme, root.Material.background,
        //     root.Material.accent, root.enabled, root.flat, root.highlighted, false /*checked*/)

        Rectangle {
            width: parent.width
            height: parent.height
            radius: root.radius
            visible: enabled && (root.hovered || root.visualFocus)
            color: root.Material.rippleColor
        }

        Rectangle {
            width: parent.width
            height: parent.height
            radius: root.radius
        }
    }
}
