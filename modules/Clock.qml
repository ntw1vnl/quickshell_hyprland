pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

import qs.widgets as Widgets
import qs.config as Config

Widgets.Chip {
    id: root

    padding: 16

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
