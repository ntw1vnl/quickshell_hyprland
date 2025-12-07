import QtQuick
import QtQuick.Controls

import "../widgets" as Widgets
import "../config" as Config

Switch {
    id: root

    indicator: Rectangle {
        implicitWidth: 48
        implicitHeight: 24
        x: root.leftPadding
        y: parent.height / 2 - height / 2
        radius: 12

        //TODO: define correct colord
        //color: root.enabled ? root.checked ? Config.Settings.colors.accent : Config.Style.controlEnabledBgColor : Config.Style.controlDisabledBgColor

        Rectangle {
            readonly property real padding: 2
            x: root.checked ? parent.width - width - padding : padding
            y: root.y
            width: height
            height: parent.height - 2 * padding
            radius: width / 2
            //TODO: define correct colord
            // color: root.enabled ? Config.Settings.colors.surface2 : Config.Settings.colors.surface1

            Behavior on x {
                SmoothedAnimation {
                    velocity: 200
                }
            }
        }
    }

    contentItem: Widgets.Text {
        text: root.text
        color: root.enabled ? Config.Style.textColor : Config.Style.textDisabledColor

        verticalAlignment: Text.AlignVCenter
        leftPadding: root.indicator.width + root.spacing
    }
}
