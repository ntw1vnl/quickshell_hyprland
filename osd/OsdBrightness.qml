pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

import qs.services as Services
import qs.utils as Utils
import qs.widgets as Widgets

RowLayout {
    id: root

    spacing: 8

    readonly property real currentValue: Services.BrightnessService.currentValue

    Widgets.MaterialIcon {
        Layout.alignment: Qt.AlignVCenter
        font.pointSize: 24
        text: Utils.MaterialIcons.getBrightnessIcon(currentValue)
    }

    Widgets.ProgressBar {
        Layout.fillWidth: true
        from: 0.0
        to: 1.0
        value: currentValue
    }

    Widgets.Text {
        Layout.alignment: Qt.AlignVCenter
        text: Utils.Display.formatPercentage(currentValue)
        font.pointSize: 14
    }
}
