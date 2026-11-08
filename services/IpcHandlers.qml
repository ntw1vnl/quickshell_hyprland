import QtQuick
import Quickshell.Io
import Quickshell

import "./" as Services

QtObject {
    id: root

    property IpcHandler nightlightHandler: IpcHandler {
        target: "nightlight"
        function refreshStatus(): void {
            Services.NightLightService.refreshStatus();
        }
    }
}
