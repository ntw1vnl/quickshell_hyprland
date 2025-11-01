pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth

import qs.config as Config
import qs.widgets as Widgets
import qs.utils as Utils

Widgets.Popup {
    id: root

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var devices: adapter?.devices
    readonly property var pairedDevices: devices?.values.filter(device => device.paired)
    readonly property var availableDevices: devices?.values.filter(device => !device.paired)

    Component {
        id: bluetoothDeviceListView

        ListView {
            id: listView
            // anchors.fill: parent
            spacing: 4
            // model: root.pairedDevices ?? undefined
            boundsBehavior: Flickable.StopAtBounds

            delegate: Rectangle {
                id: deviceDelegateRoot
                required property int index
                required property var modelData
                implicitHeight: 48
                implicitWidth: rowLayout.implicitWidth
                width: listView.width
                color: Config.Style.colors.base
                radius: 12

                RowLayout {
                    id: rowLayout
                    anchors.fill: parent
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 4

                    Widgets.MaterialIcon {
                        text: Utils.MaterialIcons.fromDesktopIconId(deviceDelegateRoot.modelData.icon)
                        font.pointSize: 12
                    }

                    Widgets.Text {
                        text: deviceDelegateRoot.modelData.name
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Widgets.Button {
                        text: {
                            switch (deviceDelegateRoot.modelData.state) {
                            case BluetoothDeviceState.Connecting:
                                return "Connecting...";
                            case BluetoothDeviceState.Connected:
                                return "Disconnect";
                            case BluetoothDeviceState.Disconnecting:
                                return "Disconnecting...";
                            case BluetoothDeviceState.Disconnected:
                                return "Connect";
                            }
                        }
                    }

                    // Widgets.Switch {
                    //     id: connectSwitch
                    //     text: "connect"
                    //     enabled: deviceDelegateRoot.index % 2 == 0
                    // }
                }
            }
        }
    }

    content: Item {
        implicitHeight: 400
        implicitWidth: 400

        ColumnLayout {
            anchors.fill: parent

            Widgets.Text {
                text: "Discovering..."
                visible: root.adapter?.discovering
            }

            Widgets.GroupBox {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 4
                title: "Paired Devices"
                showBorder: false
                Loader {
                    anchors.fill: parent
                    sourceComponent: bluetoothDeviceListView
                    onLoaded: {
                        console.log("paired devices loader loaded");
                        item.model = Qt.binding(() => {
                            return root.pairedDevices;
                        });
                    }
                }
            }

            Widgets.GroupBox {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 4
                title: "Available Devices"
                showBorder: false
                // visible: availableDevicesLoader.item?.model.size > 0
                Loader {
                    id: availableDevicesLoader
                    anchors.fill: parent
                    sourceComponent: bluetoothDeviceListView
                    onLoaded: {
                        console.log("available devices loader loaded");
                        item.model = Qt.binding(() => {
                            return root.availableDevices;
                        });
                    }
                }
            }
        }
    }
}
