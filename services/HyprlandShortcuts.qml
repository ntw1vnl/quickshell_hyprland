import QtQuick
import Quickshell.Hyprland
import Quickshell

import "./" as Services
import "../utils" as Utils

QtObject {
    id: root

    property GlobalShortcut toggleBarShortcut: GlobalShortcut {
        description: "Toggles bar visibility"
        name: "toggleBar"
        onPressed: {
            const bar = Utils.Globals.bar;
            if (!bar) {
                return;
            }
            bar.visible = !bar.visible;
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
