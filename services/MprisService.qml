pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property list<MprisPlayer> players: Mpris.players.values
    readonly property MprisPlayer activePlayer: internal.getActivePlayer()

    function getDesktopEntry(player: MprisPlayer): DesktopEntry {
        if (!player) {
            return null;
        }
        // BUG: Not calling this makes heuristicLookup return null even though
        // a non null result is expected in some cases
        const desktopEntries = DesktopEntries.applications.values;
        //for some reason Chromium does not have the "desktopEntry" property set
        const desktopEntryName = player.identity == "Chromium" ? "chromium" : player?.desktopEntry ?? "";
        return desktopEntryName != "" ? DesktopEntries.heuristicLookup(desktopEntryName) : null;
    }

    function tryFocusPlayerWindow(player: MprisPlayer) {
        if (!player) {
            return;
        }
        busctlProcess.player = player;
        busctlProcess.running = true;
    }

    function isPlayerBrowser(player: MprisPlayer): bool {
        const desktopEntry = getDesktopEntry(player);
        if (!desktopEntry) {
            return false;
        }
        return desktopEntry.categories.includes("WebBrowser");
    }

    onActivePlayerChanged: {
        internal.lastPlayer = activePlayer;
    }

    Process {
        id: busctlProcess

        property MprisPlayer player: null

        running: false
        command: ["busctl", "--user", "call", "org.freedesktop.DBus", "/org/freedesktop/DBus", "org.freedesktop.DBus", "GetConnectionUnixProcessID", "s", `${player?.dbusName ?? ""}`]
        stdout: StdioCollector {
            onStreamFinished: {
                const array = text.split(" ");
                if (array.length != 2) {
                    return;
                }
                internal.focusWindow(array[1], busctlProcess.player.trackTitle);
                busctlProcess.player = null;
            }
        }
    }

    QtObject {
        id: internal

        property MprisPlayer lastPlayer: null

        function getActivePlayer() {
            if (root.players.length == 0) {
                return null;
            }
            if (root.players.length == 1) {
                return root.players[0];
            }
            const playingPlayers = root.players.filter(player => player.isPlaying);
            if (playingPlayers.length == 0) {
                if (internal.lastPlayer) {
                    return internal.lastPlayer;
                }
                return root.players[0];
            }
            return playingPlayers[0];
        }

        function focusWindow(pid: int, trackTitle: string) {
            const toplevels = Hyprland.toplevels.values;
            const processWindows = toplevels.filter(elt => elt.lastIpcObject.pid == pid);
            if (processWindows.length == 0) {
                return;
            }
            if (processWindows.length == 1) {
                Hyprland.dispatch(`focuswindow pid:${pid}`);
            } else {
                const window = processWindows.find(window => window.title.includes(trackTitle));
                if (window) {
                    Hyprland.dispatch(`focuswindow address:${window.lastIpcObject.address}`);
                }
            }
        }
    }
}
