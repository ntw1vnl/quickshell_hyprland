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

    exclusionMode: ExclusionMode.Ignore

    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    color: "transparent"

    implicitHeight: rect.implicitHeight
    implicitWidth: rect.implicitWidth

    margins.bottom: Math.round(screen.height * 0.10)

    visible: false

    function display() {
        visible = true;
        timer.restart();
    }

    property alias content: contentLoader.sourceComponent
    property alias contentLoaderSource: contentLoader.source

    Timer {
        id: timer
        interval: 1000
        onTriggered: {
            root.visible = false;
        }
    }

    Rectangle {
        id: rect

        anchors.horizontalCenter: parent.horizontalCenter

        color: Config.Settings.theme.palette.bg
        border.width: 2
        border.color: Config.Settings.theme.palette.accent;

        implicitWidth: 380//content.implicitWidth + leftPadding + rightPadding
        // implicitWidth: Math.min(content.implicitWidth + leftPadding + rightPadding, maxWidth)
        // implicitHeight: content.implicitHeight + content.anchors.margins * 2
        implicitHeight: contentLoader.implicitHeight + 24


        Loader {
            id: contentLoader
            width: parent.width
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
        }

        // Column {
        //     id: content
        //     anchors.fill: parent
        //     anchors.margins: 8
        //     spacing: 8
        //
        //     Widgets.Text {
        //         id: title
        //         text: root.text
        //         width: parent.width
        //         wrapMode: Text.Wrap
        //         font.pointSize: 11
        //     }
        //
        //     // Widgets.Text {
        //     //     id: body
        //     //     width: parent.width
        //     //     visible: text != ""
        //     //     text: root.notification.body
        //     //     wrapMode: Text.Wrap
        //     //     font.bold: false
        //     //     font.pointSize: 11
        //     // }
        // }
    }

}
