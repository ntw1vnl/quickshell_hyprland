pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "../../popups" as Popups
import "../../widgets" as Widgets

Widgets.Chip {
    id: root

    implicitHeight: 20

    enableHover: true
    enableTaps: true

    required property SystemTrayItem systemTrayItem

    signal menuOpened(qsWindow: var)
    signal menuClosed

    tapHandler.acceptedButtons: Qt.LeftButton | Qt.RightButton
    tapHandler.onTapped: (eventPoint, button) => {
        if (button == Qt.LeftButton) {
            systemTrayItem.activate();
        } else if (button == Qt.RightButton && systemTrayItem.hasMenu) {
            if (menuLoader.active) {
                menuLoader.item.open();
            } else {
                menuLoader.activeChanged.connect(() => {
                    menuLoader.item.open();
                });
            }
        }
    }

    LazyLoader {
        id: menuLoader
        loading: true

        Popups.TrayMenu {
            id: menu
            menuHandle: root.systemTrayItem?.menu ?? null
            onMenuOpened: window => root.menuOpened(window)
            onMenuClosed: {
                root.menuClosed();
            }
            anchor {
                item: root
                edges: (Edges.Bottom | Edges.Left)
                gravity: (Edges.Bottom | Edges.Right)
            }
        }
    }

    content: Row {
        spacing: 2
        IconImage {
            id: trayIcon
            source: root.systemTrayItem?.icon ?? ""
            anchors.verticalCenter: parent.verticalCenter
            height: root.height
            width: height
        }
        Widgets.Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.systemTrayItem?.title ?? ""
            visible: false
        }
    }
}
