pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import "../config/" as Config
import "./private" as Private

PopupWindow {
    id: root

    property QsMenuHandle menuHandle

    property real padding: 8
    property real backgroundPadding: 8

    signal menuClosed
    signal menuOpened(qsWindow: var) // Correct type is QsWindow, but QML does not like that

    visible: false
    color: "transparent"

    function close() {
        visible = false;
        while (content.depth > 1)
            content.pop();
        root.menuClosed();
    }

    function open() {
        visible = true;
        root.menuOpened(root);
    }

    implicitHeight: {
        let result = 0;
        for (let child of content.children) {
            result = Math.max(child.implicitHeight, result);
        }
        return result + root.padding * 2 + root.backgroundPadding * 2;
    }

    implicitWidth: {
        let result = 0;
        for (let child of content.children) {
            result = Math.max(child.implicitWidth, result);
        }
        return result + root.padding * 2 + root.backgroundPadding * 2;
    }

    Rectangle {
        id: background
        anchors.fill: parent
        anchors.margins: root.padding
        radius: 8
        color: Config.Style.colors.mantle

        Private.TrayMenuContent {
            id: content
            anchors.fill: parent
            anchors.margins: root.backgroundPadding
            menuHandle: root.menuHandle
            onCloseRequested: {
                root.close();
            }
        }
    }
}
