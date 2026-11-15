import Quickshell
import QtQuick

import "bar"
import "config"
import "notifications"
import "osd"
import "services"

ShellRoot {
    id: root

    settings.watchFiles: true

    Connections {
        target: Settings
        function onConfigLoaded() {
            WeatherForecast.getData();
        }
    }

    Bar {}

    BatteryNotifier {}

    HyprlandShortcuts {}

    NotificationCenter {}

    IpcHandlers {}

    OsdManager {
        popup: osdPopup
    }

    OsdPopup {
        id: osdPopup
    }
}
