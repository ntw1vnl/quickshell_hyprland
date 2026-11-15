pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real step: 0.05
    property real fineStep: 0.01

    readonly property real currentValue: internal.currentValue / internal.maxValue

    signal displayOsdRequested()

    QtObject {
        id: internal
        property string value
        property int currentValue
        property int maxValue
        property bool setByUserFlag: false

        function update() {
            getCurrentBrightness.running = true;
            setByUserFlag = true;
        }
    }

    Process {
        id: setBrightness
        running: false
        command: ["brightnessctl", "set", internal.value]
        onExited: function (exitCode, exitStatus) {
            internal.update();
        }
    }

    Process {
        id: getCurrentBrightness
        running: true
        command: ["brightnessctl", "get"]
        stdout: StdioCollector {
            onStreamFinished: {
                const value = parseInt(text);
                if (value) {
                    internal.currentValue = value;
                    if (internal.setByUserFlag) {
                        root.displayOsdRequested();
                        internal.setByUserFlag = false;
                    }
                }
            }
        }
    }

    Process {
        id: getMaxBrightness
        running: true
        command: ["brightnessctl", "max"]
        stdout: StdioCollector {
            onStreamFinished: {
                const value = parseInt(text);
                if (value) {
                    internal.maxValue = value;
                }
            }
        }
    }

    function brightnessUp() {
        internal.value = `+${root.step * 100}%`;
        setBrightness.running = true;
    }

    function brightnessDown() {
        internal.value = `${root.step * 100}%-`;
        setBrightness.running = true;
    }
}
