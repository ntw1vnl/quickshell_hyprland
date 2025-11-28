pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import Quickshell.Services.UPower

import "../config" as Config

QtObject {
    id: root

    readonly property JsonObject settings: Config.Settings.battery
    readonly property real batteryLevel: UPower.displayDevice.percentage

    readonly property Timer timer: Timer {
        interval: {
            if (root.batteryLevel < settings.urgentTreshold)
                return settings.notifier.urgentIntervalSecs * 1000;
            if (root.batteryLevel < settings.criticalTreshold)
                return settings.notifier.criticalIntervalSecs * 1000;
            if (root.batteryLevel < settings.warningTreshold)
                return settings.notifier.warningIntervalSecs * 1000;
            return 0;
        }
        repeat: true
        running: UPower.displayDevice.ready && UPower.displayDevice.state != UPowerDeviceState.Charging && interval != 0
        onTriggered: {
            notificationProc.running = true;
        }
    }

    readonly property Process process: Process {
        id: notificationProc
        running: false
        command: ["notify-send", "Battery low !", "Please plug in the charger"]
    }
}
