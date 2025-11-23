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
        anchors.margins: 4

        // Centering behavior
        Binding {
            target: contentLoader
            property: "anchors.centerIn"
            value: internal.centerContent ? root : undefined
            when: internal.centerContent
        }

        // Filling behavior
        Binding {
            target: contentLoader
            property: "anchors.fill"
            value: !internal.centerContent ? root : undefined
            when: !internal.centerContent
        }

        // When centered: width follows the loaded item's implicit size
        Binding {
            target: contentLoader
            property: "width"
            value: contentLoader.item ? contentLoader.item.implicitWidth : 0
            when: internal.centerContent
        }

        // When filling: width is NOT BOUND → anchor fill defines it
        Binding {
            target: contentLoader
            property: "width"
            value: undefined
            when: !internal.centerContent
        }
    }
}
