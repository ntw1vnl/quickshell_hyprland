pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Mpris

import "../config" as Config

Singleton {
    id: root

    readonly property list<MprisPlayer> players: Mpris.players.values
    readonly property list<MprisPlayer> playersByPriority: players.filter(player => {
        if (ignoreBrowsers && internal.isPlayerBrowser(player)) {
            return false;
        }
        return true;
    }).sort((a, b) => {
        const aScore = internal.getPlayerPriority(a);
        const bScore = internal.getPlayerPriority(b);
        return bScore - aScore;
    })

    readonly property JsonObject settings: Config.Settings.modules.mpris
    readonly property MprisPlayer activePlayer: playersByPriority.length > 0 ? playersByPriority[0] : null
    property bool ignoreBrowsers: settings.ignoreBrowsers
    property bool alwaysPrioritizeMediaPlayers: settings.alwaysPrioritizeMediaPlayers //if true, priritize media players event if they are paused and a browser is playing

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

        function isPlayerBrowser(player: MprisPlayer): bool {
            const desktopEntry = root.getDesktopEntry(player);
            if (!desktopEntry) {
                return false;
            }
            return desktopEntry.categories.includes("WebBrowser");
        }

        // the higher the score the higher the possibility that the plyer will be considered as the active player
        function getPlayerPriority(player: MprisPlayer): int {
            let score = 0;
            if (!player) {
                return score;
            }
            if (player.isPlaying) {
                score += 4;
            }
            if (isPlayerBrowser(player) && root.alwaysPrioritizeMediaPlayers) {
                score -= 2;
            }
            const desktopEntry = root.getDesktopEntry(player);
            if (!desktopEntry) {
                return score;
            }
            // tested with spotify, check if other music player return same generic name
            if (desktopEntry.genericName === "Music Player") {
                score += 3;
            } else if (desktopEntry.categories.includes("Music")) {
                score += 2;
            } else if (desktopEntry.categories.includes("Player")) {
                score += 1;
            }
            return score;
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
