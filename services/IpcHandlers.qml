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

    // OSD
    property IpcHandler volumeHandler: IpcHandler {
        target: "volume"

        function up(): void {
            Services.AudioService.volumeUp();
        }

        function down(): void {
            Services.AudioService.volumeDown();
        }

        function toggleMute(): void {
            Services.AudioService.toggleMute();
        }
    }
}
