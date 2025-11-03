import QtQuick

import qs.config as Config

Rectangle {
    id: root

    implicitHeight: 28
    implicitWidth: Math.max(internal.contenWidthWithMargins, implicitHeight)
    radius: height / 2
    color: Config.Style.colors.surface0

    QtObject {
        id: internal
        property real contenWidthWithMargins: contentLoader.implicitWidth + root.leftPadding + root.rightPadding
        property bool centerContent: contenWidthWithMargins < root.implicitHeight
    }

    property alias topPadding: contentLoader.anchors.topMargin
    property alias bottomPadding: contentLoader.anchors.bottomMargin
    property alias leftPadding: contentLoader.anchors.leftMargin
    property alias rightPadding: contentLoader.anchors.rightMargin
    property alias padding: contentLoader.anchors.margins

    property alias content: contentLoader.sourceComponent

    Loader {
        id: contentLoader
        anchors.fill: !internal.centerContent ? parent : undefined
        anchors.centerIn: internal.centerContent ? parent : undefined
        anchors.margins: 4
    }
}
