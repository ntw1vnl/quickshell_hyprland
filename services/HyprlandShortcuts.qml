import QtQuick
import Quickshell.Hyprland
import Quickshell

import "./" as Services
import qs.utils as Utils

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

    property GlobalShortcut toggleCenterModule: GlobalShortcut {
        description: "Displays next center module in bar"
        name: "nextCenterBarModule"
        onPressed: {
            const switchable = Utils.Globals.centerSwitchable;
            if (!switchable) {
                return;
            }
            switchable.displayNext();
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
