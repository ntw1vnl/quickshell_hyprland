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

    content: Item {
        implicitHeight: 600
        implicitWidth: 400

        ColumnLayout {
            anchors.fill: parent

            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 4
                spacing: 4
                model: root.devices ?? undefined

                delegate: Rectangle {
                    id: deviceDelegateRoot
                    required property int index
                    required property var modelData
                    implicitHeight: 48
                    implicitWidth: rowLayout.implicitWidth
                    width: listView.width
                    color: Config.Style.colors.surface0
                    radius: 12

                    RowLayout {
                        id: rowLayout
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 2

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

                        Widgets.Switch {
                            id: connectSwitch
                            text: "connect"
                            enabled: deviceDelegateRoot.index % 2 == 0
                        }
                    }
                }
            }
        }
    }
}
