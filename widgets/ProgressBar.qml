pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import qs.config as Config

ProgressBar {
    id: root
    implicitWidth: 200
    implicitHeight: 28

    background: Rectangle {
        implicitHeight: root.implicitHeight
        implicitWidth: root.implicitWidth
        color: Config.Settings.theme.palette.bgLight
        radius: 0
    }

    contentItem: Item {
        implicitWidth: root.implicitWidth
        implicitHeight: root.implicitHeight

        Rectangle {
            width: root.visualPosition * parent.width
            height: parent.height
            color: Config.Settings.theme.palette.accent
            radius: 0
        }
    } 
}
