import Quickshell
import QtQuick
import QtQuick.Layouts

import "services"

ShellRoot {
    id: root

    settings.watchFiles: false 

    Bar {}

    BatteryNotifier {}
}
