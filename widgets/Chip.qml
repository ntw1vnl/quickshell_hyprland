import QtQuick

import "../config" as Config

Rectangle {
    id: root

    implicitHeight: 28
    implicitWidth: Math.max(internal.contenWidthWithMargins, implicitHeight)
    radius: height / 2
    color: Qt.lighter(backgroundColor, hoverHandler.hovered ? 1.6 : 1.0)

    QtObject {
        id: internal
        property real contentWidthWithMargins: contentLoader.implicitWidth + root.leftPadding + root.rightPadding
        property bool centerContent: contentWidthWithMargins < root.implicitHeight
    }

    property alias topPadding: contentLoader.anchors.topMargin
    property alias bottomPadding: contentLoader.anchors.bottomMargin
    property alias leftPadding: contentLoader.anchors.leftMargin
    property alias rightPadding: contentLoader.anchors.rightMargin
    property alias padding: contentLoader.anchors.margins

    property bool enableHover: false
    property bool enableTaps: false
    property color backgroundColor: Config.Style.colors.mantle

    property alias tapHandler: tapHandler
    property alias content: contentLoader.sourceComponent

    HoverHandler {
        id: hoverHandler
        enabled: root.enableHover
    }

    TapHandler {
        id: tapHandler
        enabled: root.enableTaps
    }

    Loader {
        id: contentLoader
        anchors.fill: !internal.centerContent ? parent : undefined
        anchors.centerIn: internal.centerContent ? parent : undefined
        width: anchors.centerIn ? item.implicitWidth : parent.width
        anchors.margins: 4
    }
}
