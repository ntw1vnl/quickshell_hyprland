import QtQuick
import Quickshell.Hyprland
import Quickshell

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
}
