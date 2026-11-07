pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    component WireguardConnection: QtObject {
        property string name: ""
        property bool active: false
    }

    Component {
        id: wireguardConnectionComp
        WireguardConnection {}
    }

    property list<WireguardConnection> connections: []

    function clearConnections() {
        connections.forEach(obj => {
            obj.destroy();
        });
        connections = [];
    }

    Process {
        id: nmcliMonitor
        running: true
        command: ["nmcli", "monitor"]
        stdout: SplitParser {
            onRead: {
                updateConnectionsProc.running = true;
            }
        }
    }

    Process {
        id: updateConnectionsProc
        property string buffer
        command: ["nmcli", "-t", "-f", "NAME,TYPE,ACTIVE", "c"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.clearConnections();
                const lines = text.split('\n');
                const parseLine = line => {
                    const fields = line.split(':');
                    if (fields.length != 3) {
                        return null;
                    }
                    if (fields[1] != "wireguard") {
                        return null;
                    }
                    return wireguardConnectionComp.createObject(root, {
                        "name": fields[0],
                        "active": fields[2] == "yes"
                    });
                };
                lines.forEach(line => {
                    let result = parseLine(line);
                    if (result) {
                        root.connections.push(result);
                    }
                });
            }
        }
    }
}
