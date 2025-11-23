pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

import "../widgets" as Widgets

Widgets.Chip {
    id: root

    padding: 16
    enableHover: true

    property string format: "ddd dd - hh:mm"

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    content: Widgets.Text {
        id: text
        verticalAlignment: Text.AlignVCenter
        text: Qt.formatDateTime(clock.date, root.format)
    }
}
