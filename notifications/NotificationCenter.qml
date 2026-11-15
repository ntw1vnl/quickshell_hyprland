pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

import qs.widgets as Widgets
import qs.config as Config

PanelWindow {
    id: root
    WlrLayershell.layer: WlrLayer.Overlay

    anchors.top: true
    anchors.right: true

    color: "transparent"

    implicitWidth: 440
    implicitHeight: column.implicitHeight + 2 * column.anchors.margins

    NotificationServer {
        id: server
        actionsSupported: true
        actionIconsSupported: true
        bodyImagesSupported: true
        imageSupported: true
        onNotification: function (notification: Notification) {
            console.log(`notification received: ${notification.body}`);
            notification.tracked = true;
            var toto;
        }
    }

    Column {
        id: column
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 12
        spacing: 8

        Repeater {
            model: server.trackedNotifications

            delegate: NotificationPopup {
                required property var modelData
                notification: modelData
                anchors.right: parent.right
            }
        }
    }
}
