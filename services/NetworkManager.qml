pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

// TODO: update when official Network api gets added to QuickShell

Singleton {
    id: root

    enum WifiStatus {
        Connected,
        Disconnected,
        Connecting,
        Unavailable,
        Limited
    }

    component Wifi: QtObject {
        property int status: NetworkManager.WifiStatus.Disconnected
        property string networkName: ""
        property int signalStrength: 0
        property bool scanning: false
        property bool connecting: false
    }

    component Ethernet: QtObject {
        property bool enabled: false
    }

    component WireguardConnection: QtObject {
        property string name: ""
        property bool active: false
        Component.onDestruction: {
            console.log(`WireguardConnection ${this} destroyed`);
        }
    }

    Component {
        id: wireguardConnectionComp
        WireguardConnection {}
    }

    property Wifi wifi: Wifi {}
    property Ethernet ethernet: Ethernet {}
    property list<WireguardConnection> activeWireguardConnections: []
    property WireguardConnection activeWireguardConnection: activeWireguardConnection

    function clearActiveWireguardConnections() {
        activeWireguardConnections.forEach(obj => {
            obj.destroy();
        });
        activeWireguardConnections = [];
    }

    QtObject {
        id: internal

        // signalStrength int between 0 and 100
        function getWifiConnectedIcon(signalStrength) {
            if (signalStrength <= 25) {
                return "network_wifi_1_bar";
            } else if (signalStrength > 25 && signalStrength <= 50) {
                return "network_wifi_2_bar";
            } else if (signalStrength > 50 && signalStrength <= 75) {
                return "network_wifi_3_bar";
            } else if (signalStrength > 75 && signalStrength <= 100) {
                return "network_wifi";
            }
        }

        function getWifiLimitedIcon(signalStrength) {
            return getWifiConnectedIcon(signalStrength) + "_locked";
        }
    }

    onActiveWireguardConnectionsChanged: {
        console.log("onActiveWireguardConnectionsChanged : " + activeWireguardConnections);
    }

    // TODO: if both ethernet and wifi are active determine the actual network type used
    property string icon: {
        if (root.ethernet.enabled) {
            return "lan";
            // return "cable";
        }
        switch (root.wifi.status) {
        case NetworkManager.WifiStatus.Connected:
        case NetworkManager.WifiStatus.Connecting:
            return internal.getWifiConnectedIcon(root.wifi.signalStrength);
        case NetworkManager.WifiStatus.Disconnected:
            return "signal_wifi_statusbar_not_connected";
        case NetworkManager.WifiStatus.Unavailable:
            return "signal_wifi_off";
        case NetworkManager.WifiStatus.Limited:
            return internal.getWifiLimitedIcon(root.wifi.signalStrength);
        }
    }

    function resetState() {
        root.ethernet.enabled = false;
        root.wifi.status = NetworkManager.WifiStatus.Disconnected;
        root.wifi.networkName = "";
        root.wifi.signalStrength = 0;
        root.wifi.connecting = false; 
        root.wifi.scanning = false; 
    }

    function updateData() {
        console.log("updateData called");
        resetState();
        updateDeviceConnections.running = true;
        updateWireguardConnections.running = true;
        updateWifiSignalStrenghConnections.running = true;
    }

    Process {
        id: nmcliMonitor
        running: true
        command: ["nmcli", "monitor"]
        stdout: SplitParser {
            onRead: {
                console.log("nmCliMonitor on read");
                root.updateData();
            }
        }
    }

    Process {
        id: updateWifiSignalStrenghConnections
        property string buffer
        command: ["sh", "-c", "nmcli -t -f ACTIVE,SIGNAL device wifi | grep '^yes'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const arr = text.split(":");
                if (arr.length != 2) {
                    console.error(`in updateWifiSignalStrenghConnections parse function, unexpected size ${arr.length}`);
                    return;
                }
                const signalStrength = Number.parseInt(arr[1]);
                if (signalStrength == NaN) {
                    return;
                }
                root.wifi.signalStrength = signalStrength;
            }
        }
    }

    Process {
        id: updateDeviceConnections
        property string buffer
        command: ["sh", "-c", "nmcli -t -f TYPE,CONNECTION,STATE d status"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                console.log("updateDeviceConnections on stream finished");
                const lines = text.split('\n');
                console.log(`lines = ${lines}`)
                lines.forEach(line => {
                    console.log(`line = ${line}`)
                    const arr = line.split(":");
                    if (arr.length != 3) {
                        console.error(`in updateDeviceConnections parse function, unexpected size ${arr.length} for ${line}`);
                        return;
                    }
                    const type = arr[0];
                    const name = arr[1];
                    const state = arr[2];

                    if (type == "ethernet" && state == "connected") {
                        root.ethernet.enabled = true;
                    } else if (type == "wifi") {
                        root.wifi.networkName = name;
                        root.wifi.status = (() => {
                            if (state == "connected") {
                                return NetworkManager.WifiStatus.Connected;
                            } else if (state == "disconnected") {
                                return NetworkManager.WifiStatus.Disconnected;
                            } else if (state == "connecting") {
                                return NetworkManager.WifiStatus.Connecting;
                            } else if (state == "unavailable") {
                                return NetworkManager.WifiStatus.Unavailable;
                            } else if (state == "limited") {
                                return NetworkManager.WifiStatus.Limited;
                            }
                        })();
                    }
                });
            }
        }
    }

    Process {
        id: updateWireguardConnections
        property string buffer
        command: ["nmcli", "-t", "-f", "NAME,TYPE,STATE", "c"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.clearActiveWireguardConnections();
                const lines = text.split('\n');
                const parseLine = line => {
                    const fields = line.split(':');
                    if (fields.length != 3) {
                        return null;
                    }
                    if (fields[1] != "wireguard") {
                        return null;
                    }
                    if (fields[2] != "activated") {
                        return null;
                    }
                    return wireguardConnectionComp.createObject(root, {
                        "name": fields[0],
                        "active": true
                    });
                };
                lines.forEach(line => {
                    let result = parseLine(line);
                    if (result) {
                        root.activeWireguardConnections.push(result);
                    }
                });
            }
        }
    }
}
