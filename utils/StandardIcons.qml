pragma Singleton

import QtQuick

import Quickshell

Singleton {
    id: root

    // https://www.nodc.noaa.gov/archive/arc0021/0002199/1.1/data/0-data/HTML/WMO-CODE/WMO4677.HTM
    function getWeatherConditionIconUrl(wmoCode: int): string {
        if (wmoCode == -1) {
            return undefined;
        }
        console.log(`getWeatherConditionIcon called, wmoCode = ${wmoCode}`);

        function getIconName(wmoCode: int): string {
            switch (wmoCode) {
            case -1:
                return "";
            case 0:
                return "weather-clear";
            case 1: //mainly clear
                return "weather-few-clouds";
            case 2: //partly cloudy
                return "weather-clouds";
            case 3: //overcast
                return "weather-overcast";
            case 45: //fog
            case 48: //depositing rime fog
                return "weather-fog";
            // case 51: //drizzle slight
            // case 53: //drizzle moderate
            // case 55: //drizzle heavy
            case 61: //rain slight
            case 63: //rain moderate
                return "weather-showers-scattered";
            case 65: //rain heavy
                return "weather-showers";
            case 71: //snow fall slight
            case 73: //snow fall moderate
                return "weather-snow-scattered";
            case 75: //snow fall heavy
                return "weather-snow";
            case 80: //rain showers slight
            case 81: //rain showers moderate
                return "weather-showers-scattered";
            case 82: //rain showers violent
                return "weather-showers";
            case 95: //thunderstorm
            case 96: //thunderstorm with slight hail
            case 99: //thunderstorm with heavy hail
                return "weather-storm";
            default:
                return "";
            }
        }

        return "image://icon/" + getIconName(wmoCode);
    }
}
