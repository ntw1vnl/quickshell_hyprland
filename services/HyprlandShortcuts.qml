import QtQuick
import Quickshell.Hyprland
import Quickshell

import "./" as Services

QtObject {
    id: root

    property PanelWindow barRef: null

    property GlobalShortcut toggleBarShortcut: GlobalShortcut {
        description: "Toggles bar visibility"
        name: "toggleBar"
        onPressed: {
            if (!root.barRef) {
                return;
            }
            root.barRef.visible = !root.barRef.visible;
        }
    }

    property GlobalShortcut refreshAvailableUpdatesShortcut: GlobalShortcut {
        description: "Refreshes the available updates"
        name: "refreshAvailableUpdates"
        onPressed: {
            Services.UpdateHandler.refresh();
        }
    }
}
