import QtQuick
import QtQuick.Controls

import "../widgets" as Widgets
import "../config" as Config

Button {
    id: root

    property int size: Config.Style.Size.Medium

    function implicitBgColor() {
        if (!root.enabled) {
            return Config.Style.controlDisabledBgColor;
        }
        if (root.pressed) {
            return Config.Style.colors.surface1;
        }
        if (root.hovered) {
            return Config.Style.colors.surface0;
        }
        return Config.Style.colors.base;
    }

    property color bgColor: implicitBgColor()

    contentItem: Widgets.Text {
        leftPadding: root.indicator.width + root.spacing
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
        text: root.text
        size: root.size
        color: root.enabled ? Config.Style.textColor : Config.Style.textDisabledColor
    }

    background: Rectangle {
        id: bgRect
        implicitWidth: 100
        implicitHeight: Config.Style.buttonSize(root.size)
        // opacity: enabled ? 1 : 0.3
        color: root.bgColor
        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
        radius: Config.Style.buttonRadius
    }
}
