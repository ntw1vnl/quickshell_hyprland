pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import "../config" as Config

Singleton {
    id: root

    readonly property JsonObject settings: Config.Settings.location

    property string lat: settings.latitude
    property string long: settings.longitude

    component WeatherData: QtObject {
        required property date date
        required property int weatherCode  //wmo code https://www.nodc.noaa.gov/archive/arc0021/0002199/1.1/data/0-data/HTML/WMO-CODE/WMO4677.HTM
        required property real temperatureCelcius2m
        required property real windspeedKmh10m
        required property real windDirectionDeg
    }

    signal dataAvailable(data: WeatherData)

    Component {
        id: weatherDataComp
        WeatherData {}
    }

    function sendRequest(url, callback) {
        let request = new XMLHttpRequest();

        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {
                let response = {
                    status: request.status,
                    headers: request.getAllResponseHeaders(),
                    contentType: request.responseType,
                    content: request.response
                };
                callback(response);
            }
        };

        request.open("GET", url);
        request.send();
    }

    function getData() {
        if (root.lat == "" && root.long == "") {
            return;
        }
        // qmlformat off
        const url = "https://api.open-meteo.com/v1/forecast?" +
        `latitude=${root.lat}` +
        `&longitude=${root.long}` +
        `&hourly=temperature_2m,windspeed_10m,winddirection_10m,weather_code` +
        `&timezone=auto`;
        // qmlformat on

        console.log(`url = ${url}`);

        const now = new Date();
        now.setMinutes(0);
        now.setSeconds(0);
        now.setMilliseconds(0);
        const currentDateTime = Qt.formatDateTime(now, Qt.ISODate).slice(0, -3); //strip seconds
        // console.log(`currentDateTime = ${currentDateTime}`);

        root.sendRequest(url, function (response) {
            // console.log(`status = ${response.status}`);
            if (response.status !== 200) {
                console.warn(`error : ${response.content}`);
                return;
            }
            // console.log(`content = ${response.content}`);
            const obj = JSON.parse(response.content);
            const timeArray = obj["hourly"]["time"];
            console.log(`timeArray length = ${timeArray.length}`);
            // console.log(`timeArray = ${timeArray}`);
            const currentTimeIndex = timeArray.findIndex(elt => {
                return elt == currentDateTime;
            });
            if (currentTimeIndex == -1) {
                console.warn(`error : current time index not found`);
                return;
            }

            const timesToFind = ["00:00", "08:00", "12:00", "18:00"];
            // const timesToFind = ["08:00", "12:00", "18:00"];
            console.log(`currentTimeIndex = ${currentTimeIndex}`);
            console.log(`timeArray.length = ${timeArray.length}`);

            let nextDesiredTimeIndex = (() => {
                    for (let i = currentTimeIndex + 1; i < timeArray.length; i++) {
                        const currentTime = timeArray[i];
                        // console.log(`currentTime = ${currentTime}`);
                        const nextTimeIndex = timesToFind.findIndex(elt => {
                            return currentTime.endsWith(elt);
                        });
                        if (nextTimeIndex != -1) {
                            return i;
                        }
                    }
                    return -1;
                })();

            console.log(`nextDesiredTimeIndex = ${nextDesiredTimeIndex}`);
            const hourly = obj["hourly"];
            const temp = obj["hourly"]["temperature_2m"][nextDesiredTimeIndex];
            const windSpeed = obj["hourly"]["windspeed_10m"][nextDesiredTimeIndex];
            const windDirection = obj["hourly"]["winddirection_10m"][nextDesiredTimeIndex];
            const weatherCode = obj["hourly"]["weather_code"][nextDesiredTimeIndex];
            console.log(`temp = ${temp}, windSpeed = ${windSpeed}, windDirection = ${windDirection}, weatherCode = ${weatherCode}`);

            root.dataAvailable(weatherDataComp.createObject(root, {
                "date": timeArray[nextDesiredTimeIndex],
                "weatherCode": hourly["weather_code"][nextDesiredTimeIndex],
                "temperatureCelcius2m": Math.round(hourly["temperature_2m"][nextDesiredTimeIndex]),
                "windspeedKmh10m": Math.round(hourly["windspeed_10m"][nextDesiredTimeIndex]),
                "windDirectionDeg": hourly["winddirection_10m"][nextDesiredTimeIndex]
            }));
        });
    }
}
