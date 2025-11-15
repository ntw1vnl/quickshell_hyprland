import Quickshell
import QtQuick

import "services"

ShellRoot {
    id: root

    settings.watchFiles: false 

    Bar {}

    BatteryNotifier {}
}
