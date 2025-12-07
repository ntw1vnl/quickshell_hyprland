import QtQuick
import QtQuick.Controls

import "../widgets" as Widgets
import "../config" as Config

Button {
    id: root

    property int size: Config.Style.Size.Medium

    function implicitBgColor() {
        if (!root.enabled) {
            //TODO: define better color ?
            return Config.Settings.colors.bgLight;
        }
        if (root.pressed) {
            return Qt.lighter(Config.Settings.colors.bg, 1.8);
        }
        if (root.hovered) {
            return Qt.lighter(Config.Settings.colors.bg, 1.6);
        }
        return Config.Settings.colors.bg;
    }

    property color bgColor: implicitBgColor()

    contentItem: Widgets.Text {
        leftPadding: root.indicator.width + root.spacing
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
        text: root.text
        size: root.size
        color: root.enabled ? Config.Settings.colors.text : Config.Settings.colors.textDisabled
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
