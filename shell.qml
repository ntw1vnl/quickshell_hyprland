import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.services

ShellRoot {
    id: root

    settings.watchFiles: false 

    Bar {}

    BatteryNotifier {}
}
