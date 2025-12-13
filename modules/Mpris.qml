pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Widgets
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "../widgets" as Widgets
import "../config" as Config
import "../services" as Services

Widgets.Chip {
    id: root

    enableHover: true
    enableTaps: true
    leftPadding: 8
    rightPadding: 8
    topPadding: 0
    bottomPadding: 0

    readonly property JsonObject settings: Config.Settings.modules.mpris
    readonly property MprisPlayer activePlayer: ignoreBrowsers && Services.MprisService.isPlayerBrowser(Services.MprisService.activePlayer) ? null : Services.MprisService.activePlayer
    readonly property DesktopEntry activePlayerDesktopEntry: Services.MprisService.getDesktopEntry(activePlayer)
    readonly property bool canGoNext: root.activePlayer?.canGoNext ?? false
    readonly property bool canGoPrevious: root.activePlayer?.canGoPrevious ?? false

    property real maxDisplayTextWidth: settings.maxDisplayTextWidth
    property bool displayProgessBar: settings.displayProgressBar
    property bool ignoreBrowsers: settings.ignoreBrowsers

    onHoveredChanged: {
        internal.animateText = hovered;
    }

    function playNext() {
        if (canGoNext) {
            activePlayer.next();
        }
    }

    function playPrevious() {
        if (canGoPrevious) {
            activePlayer.previous();
        }
    }

    onLeftClicked: {
        if (activePlayer) {
            activePlayer.togglePlaying();
        }
    }

    onRightClicked: {
        Services.MprisService.tryFocusPlayerWindow(activePlayer);
    }

    visible: activePlayer != null

    WheelHandler {
        id: wheelHandler
        enabled: true
        acceptedDevices: PointerDevice.TouchPad
        orientation: Qt.Horizontal
        onWheel: event => {
            root.contentItem.buttonWrapper.handleWheel(event);
        }
        onActiveChanged: {
            if (!active) {
                root.contentItem.buttonWrapper.handleReleased();
            }
        }
    }

    QtObject {
        id: internal
        property bool animateText: false

        function displayString(player: MprisPlayer): string {
            if (!player) {
                return "";
            }
            const trackAlbumArtist = player.trackAlbumArtist;
            if (trackAlbumArtist != "") {
                return `${trackAlbumArtist} - ${player.trackTitle}`;
            }
            return player.trackTitle;
        }
    }

    content: RowLayout {
        spacing: 6

        property alias buttonWrapper: buttonWrapper

        Widgets.MaterialIcon {
            id: fallbackIcon
            Layout.alignment: Qt.AlignVCenter
            text: "music_note"
            font.pointSize: 14
            visible: !iconImage.visible
        }

        IconImage {
            id: iconImage
            Layout.alignment: Qt.AlignVCenter
            visible: status != Image.Null
            source: Quickshell.iconPath(root.activePlayerDesktopEntry?.icon, true)
            implicitSize: 20
        }

        Item {
            Layout.fillHeight: true
            Layout.maximumWidth: root.maxDisplayTextWidth
            Layout.preferredWidth: displayText.implicitWidth

            Item {
                id: textContainer
                anchors.fill: parent
                clip: true

                property int scrollSpeed: 30 //pixels per second
                property int pauseDuration: 1000 //milliseconds
                property int fadeWidth: 15

                Connections {
                    target: internal
                    function onAnimateTextChanged() {
                        textContainer.toggleScroll();
                    }
                }

                function toggleScroll() {
                    if (displayText.paintedWidth <= textContainer.width) {
                        if (anim.running) {
                            anim.restart();
                            anim.stop();
                        }
                        return;
                    }
                    if (internal.animateText) {
                        anim.restart();
                    } else {
                        anim.restart();
                        anim.stop();
                    }
                }

                Rectangle {
                    id: fadeLeft
                    width: textContainer.fadeWidth
                    height: parent.height
                    anchors.left: parent.left
                    z: 1
                    visible: displayText.x < 0
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop {
                            position: 0.0
                            color: root.bgColor
                        }
                        GradientStop {
                            id: fadeLeftTranparentStop
                            position: 0.0
                            color: "transparent"
                        }
                    }
                }

                Widgets.Text {
                    id: displayText
                    x: 0
                    anchors.verticalCenter: parent.verticalCenter
                    text: internal.displayString(root.activePlayer)
                    elide: Text.ElideRight
                }

                Rectangle {
                    id: fadeRight
                    width: textContainer.fadeWidth
                    height: parent.height
                    anchors.right: parent.right
                    z: 1
                    visible: displayText.x > textContainer.width - displayText.paintedWidth
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop {
                            id: fadeRightTranparentStop
                            position: 0.0
                            color: "transparent"
                        }
                        GradientStop {
                            position: 1.0
                            color: root.bgColor
                        }
                    }
                }

                SequentialAnimation {
                    id: anim
                    loops: Animation.Infinite

                    property real duration: {
                        var dist = Math.abs(textContainer.width - displayText.paintedWidth);
                        return dist / textContainer.scrollSpeed * 1000;
                    }

                    property int easingType: Easing.InOutSine

                    // Scroll forward (to the left)
                    ParallelAnimation {
                        NumberAnimation {
                            targets: [fadeLeftTranparentStop, fadeRightTranparentStop]
                            property: "position"
                            from: 0.0
                            to: 1.0
                            duration: anim.duration
                            easing.type: anim.easingType
                        }
                        NumberAnimation {
                            target: displayText
                            property: "x"
                            from: 0
                            to: textContainer.width - displayText.paintedWidth
                            duration: anim.duration
                            easing.type: anim.easingType
                        }
                    }

                    PauseAnimation {
                        duration: textContainer.pauseDuration
                    }

                    // Scroll backward (to original position)
                    ParallelAnimation {
                        NumberAnimation {
                            targets: [fadeLeftTranparentStop, fadeRightTranparentStop]
                            property: "position"
                            from: 1.0
                            to: 0.0
                            duration: anim.duration
                            easing.type: anim.easingType
                        }
                        NumberAnimation {
                            target: displayText
                            property: "x"
                            from: textContainer.width - displayText.paintedWidth
                            to: 0
                            duration: anim.duration
                            easing.type: anim.easingType
                        }
                    }

                    PauseAnimation {
                        duration: textContainer.pauseDuration
                    }
                }
            }

            Rectangle {
                id: progressBar
                y: displayText.y + displayText.height
                anchors.left: parent.left
                height: 2
                radius: height / 2
                width: progressWidth
                color: Config.Settings.colors.green
                visible: root.displayProgessBar && progressSupported

                readonly property bool progressSupported: root.activePlayer ? root.activePlayer.positionSupported && root.activePlayer.lengthSupported : false
                readonly property real progressWidth: {
                    if (!progressSupported) {
                        return 0;
                    }
                    return Math.min(root.activePlayer.position / root.activePlayer.length, 1) * parent.width;
                }

                Timer {
                    running: progressBar.visible && root.activePlayer?.playbackState == MprisPlaybackState.Playing
                    interval: 1000
                    repeat: true
                    onTriggered: root.activePlayer.positionChanged()
                }
            }
        }

        Item {
            id: buttonWrapper
            implicitWidth: playPauseButton.implicitWidth + padding * 2
            implicitHeight: buttonRow.implicitHeight
            clip: true

            property real padding: 2
            property real offset: 0
            readonly property real leftTreshold: -skipPreviousButton.width - padding
            readonly property real rightTreshold: skipNextButton.width + padding
            readonly property real defaultX: leftTreshold
            readonly property real buttonWidth: 20

            property alias snapbackAnimation: snapbackAnimation
            property alias buttonRow: buttonRow

            function handleWheel(wheelEvent) {
                const deltaX = wheelEvent.pixelDelta.x;
                let tempOffset = offset - deltaX;
                if (tempOffset > rightTreshold) {
                    tempOffset = rightTreshold;
                } else if (tempOffset < leftTreshold) {
                    tempOffset = leftTreshold;
                }
                if (!root.canGoPrevious && tempOffset > 0 || !root.canGoNext && tempOffset < 0) {
                    return;
                }
                offset = tempOffset;
            }

            function handleReleased() {
                snapbackAnimation.from = buttonRow.x;
                snapbackAnimation.to = defaultX;
                if (offset <= leftTreshold) {
                    root.playNext();
                } else if (offset >= rightTreshold) {
                    root.playPrevious();
                }
                snapbackAnimation.start();
            }

            NumberAnimation {
                id: snapbackAnimation
                target: buttonRow
                property: "x"
                duration: 500
                running: false
                easing.type: Easing.OutExpo
                onStopped: {
                    buttonWrapper.offset = 0;
                }
            }

            Row {
                id: buttonRow
                spacing: buttonWrapper.padding
                x: buttonWrapper.defaultX + buttonWrapper.offset
                leftPadding: buttonWrapper.padding
                rightPadding: buttonWrapper.padding
                Widgets.MaterialIcon {
                    id: skipPreviousButton
                    width: implicitWidth
                    text: "skip_previous"
                    font.pointSize: 14
                }
                Widgets.MaterialIcon {
                    id: playPauseButton
                    text: root.activePlayer?.isPlaying ? "pause" : "play_arrow"
                    font.pointSize: 14
                }
                Widgets.MaterialIcon {
                    id: skipNextButton
                    width: implicitWidth
                    text: "skip_next"
                    font.pointSize: 14
                }
            }
        }
    }
}
