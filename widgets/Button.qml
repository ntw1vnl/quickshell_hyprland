import QtQuick
import QtQuick.Controls

import qs.widgets as Widgets
import qs.config as Config

Button {
    id: root

    property int size: Config.Style.Size.Medium

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
        implicitWidth: 100
        implicitHeight: Config.Style.buttonSize(root.size)
        opacity: enabled ? 1 : 0.3
        color: {
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
        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
        radius: Config.Style.buttonRadius
    }
}
