pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    QtObject {
        id: internal

        function getIndex(value: real, length: int): int {
            return Math.min(Math.floor(value * length), length - 1);
        }
    }

    function getVolumeIcon(volume: real, isMuted: bool): string {
        if (isMuted)
            return "no_sound";
        if (volume >= 0.5)
            return "volume_up";
        if (volume > 0)
            return "volume_down";
        return "no_sound";
    }

    function getWifiConnectedIcon(signalStrength) {
        // signalStrength int from 0 to 100
        const arr = ["network_wifi_1_bar", "network_wifi_2_bar", "network_wifi_3_bar", "network_wifi"];
        return arr[internal.getIndex(signalStrength / 100, arr.length)];
    }

    function getWifiLimitedIcon(signalStrength) {
        return getWifiConnectedIcon(signalStrength) + "_locked";
    }

    function getUPowerDeviceIcon(deviceType) {
        switch (deviceType) {
        case UPowerDeviceType.GamingInput:
            return "stadia_controller";
        case UPowerDeviceType.Headset:
            return "headset_mic";
        case UPowerDeviceType.Headphones:
            return "headphones";
        case UPowerDeviceType.Mouse:
            return "mouse";
        case UPowerDeviceType.Keyboard:
            return "keyboard";
        default:
            break;
        }
        return "";
    }

    function getBatteryIcon(level) {
        //level from 0 to 1
        const arr = ["battery_0_bar", "battery_1_bar", "battery_2_bar", "battery_3_bar", "battery_4_bar", "battery_5_bar", "battery_6_bar", "battery_full"];
        return arr[internal.getIndex(level, arr.length)];
    }

    function getBatteryChargingIcon(level) {
        //level from 0 to 1
        const arr = ["battery_charging_full" //use this because it looks empty not full
            , "battery_charging_20", "battery_charging_30", "battery_charging_50", "battery_charging_60", "battery_charging_80", "battery_charging_90"];
        return arr[internal.getIndex(level, arr.length)];
    }

    function fromDesktopIconId(id: string): string {
        if (id == "audio-headset") {
            return "headset_mic";
        } else if (id == "input-gaming") {
            return "stadia_controller";
        }
        return "";
    }
}
