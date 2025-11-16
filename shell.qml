import Quickshell
import QtQuick

import "services"

ShellRoot {
    id: root

    settings.watchFiles: true

    Bar {}

    BatteryNotifier {}
}
