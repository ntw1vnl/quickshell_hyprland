pragma Singleton

import QtQuick
import Quickshell

import "../config" as Config

Singleton {
    id: root

    QtObject {
        id: internal

        function batteryLevelColor(value, defaultColor) {
            //value float between 0 and 1
            if (value <= Config.Settings.battery.criticalTreshold) {
                return Config.Settings.colors.red;
            } else if (value <= Config.Settings.battery.warningTreshold) {
                return Config.Settings.colors.yellow;
            }
            return defaultColor;
        }
    }

    function formatPercentage(value) {
        //value float between 0 and 1
        return `${Math.round(value * 100)} %`;
    }

    function batteryLevelBgColor(value) {
        return internal.batteryLevelColor(value, Config.Settings.colors.green);
    }

    function batteryLevelTextColor(value) {
        return internal.batteryLevelColor(value, Config.Settings.colors.text);
    }
}
