pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property bool isIdentityProfile: internal.isIdentityProfile
    readonly property bool active: internal.active

    Component.onCompleted: {
        refreshStatus();
    }

    function refreshStatus() {
        hyprsunsetProfileProc.running = true;
        hyprsunsetIsIdentityProc.running = true;
    }

    QtObject {
        id: internal
        property bool active: false
        property bool isIdentityProfile: false
    }

    readonly property Process hyprsunsetProfileProc: Process {
        running: false
        command: ["hyprctl", "hyprsunset", "profile"]
        stdout: StdioCollector {
            onStreamFinished: {
                const arr = text.split("\n").filter(item => item);
                internal.isIdentityProfile = arr.find(elt => elt == "Identity: true") != undefined;
            }
        }
    }

    readonly property Process hyprsunsetIsIdentityProc: Process {
        running: false
        command: ["hyprctl", "hyprsunset", "identity", "get"]
        stdout: StdioCollector {
            onStreamFinished: {
                const trimmedText = text.trim();
                internal.active = (trimmedText == "false");
            }
        }
    }
}
