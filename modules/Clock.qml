import Quickshell
import QtQuick

import qs.widgets as Widgets
import qs.config as Config

Item {
    id: root

    property real padding: 16
    property string format: "ddd dd - hh:mm"

    implicitHeight: 28
    implicitWidth: text.implicitWidth + padding * 2

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Widgets.Text {
        id: text
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, root.format)
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        z: text.z - 1
        color: Config.Style.colors.surface0
        radius: height / 2
    }
}
