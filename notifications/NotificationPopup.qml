import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import Quickshell.Widgets
import Quickshell

import qs.config as Config
import qs.widgets as Widgets

Rectangle {
    id: root

    required property Notification notification

    property real iconSize: 32

    color: Config.Settings.theme.palette.bg
    border.width: 2
    border.color: {
        switch (notification.urgency) {
        case NotificationUrgency.Low:
            return Config.Settings.theme.palette.accent;
        case NotificationUrgency.Normal:
            return Config.Settings.theme.palette.accent;
        case NotificationUrgency.Critical:
            return Config.Settings.theme.palette.red;
        }
    }

    implicitWidth: 380
    implicitHeight: content.implicitHeight + content.anchors.margins * 2

    TapHandler {
        onTapped: {
            notification.dismiss();
        }
    }

    Timer {
        interval: {
            switch (notification.urgency) {
            case NotificationUrgency.Low:
                return 3000;
            case NotificationUrgency.Normal:
                return 5000;
            case NotificationUrgency.Critical:
                return 7000;
            }
        }
        running: true
        onTriggered: {
            root.notification.expire();
        }
    }

    RowLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        IconImage {
            id: appIcon
            Layout.alignment: Layout.AlignVCenter
            source: Quickshell.iconPath(root.notification.appIcon, true)
            visible: status == Image.Ready
            implicitSize: root.iconSize
        }

        IconImage {
            id: image
            Layout.alignment: Layout.AlignVCenter
            source: root.notification.image
            visible: status == Image.Ready
            implicitSize: root.iconSize
        }

        Column {
            Layout.fillWidth: true

            Widgets.Text {
                id: title
                text: root.notification.summary
                width: parent.width
                wrapMode: Text.Wrap
                font.pointSize: 11
                color: root.notification.urgency == NotificationUrgency.Critical ? Config.Settings.theme.palette.red : Config.Settings.theme.palette.text
            }

            Widgets.Text {
                id: body
                width: parent.width
                visible: text != ""
                text: root.notification.body
                wrapMode: Text.Wrap
                font.bold: false
                font.pointSize: 11
            }

        }
    }
}
