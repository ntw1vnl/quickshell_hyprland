pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import "../config" as Config
import "../widgets" as Widgets

Widgets.Chip {
    id: root

    padding: 16
    enableHover: true

    readonly property JsonObject settings: Config.Settings.modules.clock
    readonly property string defaultFormat: "ddd dd - hh:mm"
    property string format: settings.format ?? defaultFormat

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    content: Widgets.Text {
        id: text
        verticalAlignment: Text.AlignVCenter
        text: Qt.formatDateTime(clock.date, root.format)
    }
}
