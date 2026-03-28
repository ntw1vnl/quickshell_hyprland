pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import "../config" as Config

Singleton {
    id: root

    property int pacmanUpdatesCount: -1
    property int yayUpdatesCount: -1
    property bool kernelUpdateAvailable: false
    readonly property int totalUpdatesCount: pacmanUpdatesCount + yayUpdatesCount

    Component.onCompleted: {
        refresh();
    }

    function refresh() {
        queryPacmanUpdatesProc.running = true;
        queryYayUpdatesProc.running = true;
    }

    readonly property Timer timer: Timer {
        interval: 1600 * 1000 //30 min
        repeat: true
        running: true
        onTriggered: {
            queryPacmanUpdatesProc.running = true;
            queryYayUpdatesProc.running = true;
        }
    }

    readonly property Process queryPacmanUpdatesProc: Process {
        running: false
        command: ["sh", "-c", "checkupdates"]
        stdout: StdioCollector {
            onStreamFinished: {
                const arr = text.split("\n").filter(item => item);
                root.kernelUpdateAvailable = arr.find(elt => elt.startsWith("linux ")) != undefined;
                root.pacmanUpdatesCount = arr.length;
            }
        }
    }

    readonly property Process queryYayUpdatesProc: Process {
        running: false
        command: ["sh", "-c", "yay -Qum | wc -l"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.yayUpdatesCount = Number(text);
            }
        }
    }
}
