pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Io

import "../widgets" as Widgets
import "../services" as Services
import "../utils" as Utils

Widgets.Chip {
    id: root

    leftPadding: 16
    rightPadding: 16
    enableHover: true

    property var data

    component TextWithUnit: Row {
        id: row
        spacing: 2
        property alias value: valueText.text
        property alias unit: unitText.text
        Widgets.Text {
            id: valueText
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 10
        }
        Widgets.Text {
            id: unitText
            anchors.bottom: valueText.bottom
            font.pointSize: 8
        }
    }

    Connections {
        target: Services.WeatherForecast
        function onDataAvailable(data) {
            console.log(`weather data available`);
            root.data = data;
            console.log(`data.weatherCode = ${data.weatherCode}`);
        }
    }

    content: Row {
        spacing: 4
        Widgets.Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Qt.formatDateTime(root.data.date, "ddd hh:mm")
            font.pointSize: 10
        }

        IconImage {
            anchors.verticalCenter: parent.verticalCenter
            height: 24
            width: height
            source: Utils.StandardIcons.getWeatherConditionIconUrl(root.data.weatherCode ?? -1)
        }

        // Widgets.MaterialIcon {
        //     id: weatherConditionIcon
        //     anchors.verticalCenter: parent.verticalCenter
        //     text: Utils.MaterialIcons.getWeatherConditionIcon(root.data.weatherCode ?? -1)
        //     font.pointSize: 14
        // }

        TextWithUnit {
            value: root.data.temperatureCelcius2m
            unit: "°C"
        }
        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            text: "air"
            font.pointSize: 14
        }
        TextWithUnit {
            height: parent.height
            value: root.data.windspeedKmh10m
            unit: "km/h"
        }
        Widgets.MaterialIcon {
            id: windDirectionIcon
            text: "north"
            font.pointSize: 12
            transform: Rotation {
                origin.x: windDirectionIcon.width / 2
                origin.y: windDirectionIcon.height / 2
                angle: root.data.windDirectionDeg + 180
            }
        }
    }
}
