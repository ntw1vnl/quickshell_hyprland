import QtQuick

import "../config" as Config

Item {
    id: root

    implicitHeight: 28
    implicitWidth: Math.max(internal.contentWidthWithMargins, implicitHeight)

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

    property bool enableHover: true
    property bool enableTaps: true

    property alias radius: background.radius
    property color bgColor: Qt.lighter(Config.Settings.colors.bg,
                                       root.hoverHandler.hovered ? 1.6 : 1.0)

    readonly property bool hovered: hoverHandler.hovered
    property alias hoverHandler: hoverHandler
    property alias tapHandler: tapHandler
    property alias content: contentLoader.sourceComponent

    signal leftClicked
    signal rightClicked

    Rectangle {
        id: background
        anchors.fill: parent
        color: root.bgColor
        radius: height / 2
        clip: true
    }

    HoverHandler {
        id: hoverHandler
        enabled: root.enableHover
    }

    TapHandler {
        id: tapHandler
        enabled: root.enableTaps
        acceptedButtons: Qt.RightButton | Qt.LeftButton
        onSingleTapped: (point, button) => {
            if (button == Qt.LeftButton) {
                root.leftClicked();
            } else if (button == Qt.RightButton) {
                root.rightClicked();
            }
        }
    }

    Loader {
        id: contentLoader
        anchors.margins: 4
        clip: true

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
