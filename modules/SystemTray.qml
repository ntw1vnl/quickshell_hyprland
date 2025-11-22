pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Hyprland
import Quickshell.Services.SystemTray

import "../widgets" as Widgets
import "./private" as Private

Widgets.Chip {
    id: root

    visible: SystemTray.items.values.length > 0

    readonly property bool popupVisible: activeMenu != null
    property var activeMenu: null

    function grabFocus() {
        focusGrab.active = true;
    }

    function setExtraWindowAndGrabFocus(window) {
        root.activeMenu = window;
        root.grabFocus();
    }

    function releaseFocus() {
        focusGrab.active = false;
    }

    HyprlandFocusGrab {
        id: focusGrab
        active: false
        windows: [root.activeMenu]
        onCleared: {
            if (root.activeMenu) {
                root.activeMenu.close();
                root.activeMenu = null;
            }
        }
    }

    content: Row {
        anchors.verticalCenter: parent.verticalCenter
        Repeater {
            model: SystemTray.items
            delegate: Private.TrayItem {
                required property SystemTrayItem modelData
                systemTrayItem: modelData
                onMenuOpened: qsWindow => {
                    root.setExtraWindowAndGrabFocus(qsWindow);
                }
                onMenuClosed: {
                    root.releaseFocus();
                }
            }
        }
    }
}
