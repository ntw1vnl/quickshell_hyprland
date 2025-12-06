import Quickshell
import QtQuick

import "services"

ShellRoot {
    id: root

    settings.watchFiles: true

    Bar {
        id: bar
    }

    BatteryNotifier {}

    HyprlandShortcuts {
        barRef: bar
    }
}
