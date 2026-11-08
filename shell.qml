import Quickshell
import QtQuick

import "services"
import "config"
import "bar"

ShellRoot {
    id: root

    settings.watchFiles: true

    Connections {
        target: Settings
        onConfigLoaded: {
            WeatherForecast.getData();
        }
    }

    Bar {
        id: bar
    }

    BatteryNotifier {}

    HyprlandShortcuts {}

    IpcHandlers {}
}
