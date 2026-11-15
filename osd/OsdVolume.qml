pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import qs.services as Services
import qs.utils as Utils
import qs.widgets as Widgets

RowLayout {
    id: root

    spacing: 8

    Widgets.MaterialIcon {
        Layout.alignment: Qt.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: 24
        text: Services.AudioService.audioNode ? Utils.MaterialIcons.getVolumeIcon(Services.AudioService.volume, Services.AudioService.muted) : "no_sound"
    }

    Widgets.ProgressBar {
        Layout.fillWidth: true
        from: 0.0
        to: 1.0
        value: Services.AudioService.volume
    }

    Widgets.Text {
        Layout.alignment: Qt.AlignVCenter
        text: Utils.Display.formatPercentage(Services.AudioService.volume)
        font.pointSize: 14
    }
}
