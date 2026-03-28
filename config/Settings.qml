pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias battery: adapter.battery
    property alias modules: adapter.modules
    property alias style: adapter.style

    property Theme theme: Style.getThemeByName(style.theme, style.customThemes)

    readonly property ColorPalette colors: theme?.palette ?? Style.defaultTheme.palette

    FileView {
        path: `${Quickshell.shellDir}/config.json`
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: adapter
            property JsonObject battery: JsonObject {
                property real warningTreshold: 0.25
                property real criticalTreshold: 0.10
                property real urgentTreshold: 0.03
                property JsonObject notifier: JsonObject {
                    property int warningIntervalSecs: 300
                    property int criticalIntervalSecs: 60
                    property int urgentIntervalSecs: 20
                }
            }
            property JsonObject modules: JsonObject {
                property JsonObject clock: JsonObject {
                    property string format: "ddd dd - hh:mm"
                    property list<string> leftClickedCmd
                    property list<string> rightClickedCmd
                }
                property JsonObject updates: JsonObject {
                    property list<string> leftClickedCmd
                    property list<string> rightClickedCmd
                    property int minTreshold: 0
                }
                property JsonObject bluetooth: JsonObject {
                    property string displayMode: "DisplayIconOnly"
                    property bool batteryLevelAsBackground: true
                    property list<string> leftClickedCmd
                    property list<string> rightClickedCmd
                    // expected array of Objects as :
                    // {
                    //  "pattern": "regex",
                    //  "alias": "replacement"
                    // }
                    property list<var> deviceAliases
                }
                property JsonObject network: JsonObject {
                    property string displayMode: "DisplayNone"
                    property list<string> leftClickedCmd
                    property list<string> rightClickedCmd
                }
                property JsonObject wireguard: JsonObject {
                    property string displayMode: "DisplayAll"
                    property bool displayOnlyActiveConnections: false
                    property string displayPattern
                    property list<string> preferredConnections
                    property list<string> leftClickedCmd
                    property list<string> rightClickedCmd
                }
                property JsonObject volume: JsonObject {
                    property string displayMode: "DisplayNone"
                    property list<string> leftClickedCmd
                }
                property JsonObject battery: JsonObject {
                    property string displayMode: "DisplayFull"
                    property bool ignoreBluetoothDevices: false
                    property list<string> leftClickedCmd
                    property list<string> rightClickedCmd
                }
                property JsonObject mpris: JsonObject {
                    property bool displayProgressBar: true
                    property bool ignoreBrowsers: false
                    property real maxDisplayTextWidth: 200
                }
            }
            property JsonObject style: JsonObject {
                property string theme: "catpuccin-mocha"
                property list<var> customThemes
            }
        }
    }
}
