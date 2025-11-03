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

    // TODO: handle wifi network name
    component Wifi: QtObject {
        property int wifiStatus: NetworkManager.WifiStatus.Disconnected
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

    onActiveWireguardConnectionsChanged: {
        console.log("onActiveWireguardConnectionsChanged : " + activeWireguardConnections);
    }

    // TODO: if both ethernet and wifi are active determine the actual network type used
    property string icon: {
        if (root.ethernet.enabled) {
            return "lan";
            // return "cable";
        }
        return root.wifi.enabled ? "wifi" : "wifi_off";
    }

    function updateData() {
        console.log("updateData called");
        updateDeviceConnections.running = true;
        updateWireguardConnections.running = true;
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
        id: updateDeviceConnections
        property string buffer
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE d status && nmcli -t -f CONNECTIVITY g"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                console.log("updateDeviceConnections on stream finished");
                const lines = text.split('\n');
                const connectivity = lines.pop();
                lines.forEach(line => {
                    if (line.includes("ethernet") && line.includes("connected")) {
                        root.ethernet.enabled = true;
                    } else if (line.includes("wifi")) {
                        root.wifi.status = () => {
                            if (line.includes("connected")) {
                                return NetworkManager.WifiStatus.Connected;
                            } else if (line.includes("disconnected")) {
                                return NetworkManager.WifiStatus.Disconnected;
                            } else if (line.includes("connecting")) {
                                return NetworkManager.WifiStatus.Connecting;
                            } else if (line.includes("unavailable")) {
                                return NetworkManager.WifiStatus.Unavailable;
                            } else if (connectivity == "limited") {
                                return NetworkManager.WifiStatus.Limited;
                            }
                        };
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
