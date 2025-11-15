pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import Quickshell.Services.UPower

QtObject {
    id: root

    property real warningTreshold: 0.20
    property real criticalTreshold: 0.05
    property real urgentTreshold: 0.01

    property int warningInterval: 60000 * 5 // 5min
    property int criticalInterval: 60000 // 1min
    property int urgentInterval: 10000 // 10s

    readonly property real batteryLevel: UPower.displayDevice.percentage

    readonly property Timer timer: Timer {
        interval: {
            if (root.batteryLevel < root.urgentTreshold)
            return root.urgentInterval;
            if (root.batteryLevel < root.criticalTreshold)
            return root.criticalInterval;
            if (root.batteryLevel < root.warningTreshold)
            return root.warningInterval;
            return 0;
        }
        repeat: true
        running: UPower.displayDevice.ready && interval != 0
        onTriggered: {
            console.log("timer triggerd");
            notificationProc.running = true;
        }
    }

    readonly property Process process: Process {
        id: notificationProc
        running: false
        command: ["notify-send", "Battery low !", "Please plug in the charger"]
    }
}
