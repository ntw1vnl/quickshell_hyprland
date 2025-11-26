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

    property real maxDisplayTextWidth: 200
    property bool ignoreBrowsers: false
    readonly property MprisPlayer activePlayer: ignoreBrowsers && Services.MprisService.isPlayerBrowser(Services.MprisService.activePlayer) ? null : Services.MprisService.activePlayer
    readonly property DesktopEntry activePlayerDesktopEntry: Services.MprisService.getDesktopEntry(activePlayer)

    onHoveredChanged: {
        internal.animateText = hovered;
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
            id: textContainer
            Layout.fillHeight: true
            Layout.maximumWidth: root.maxDisplayTextWidth
            implicitWidth: displayText.implicitWidth
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
                        color: root.color
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
                        color: root.color
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

        Widgets.MaterialIcon {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            text: root.activePlayer?.isPlaying ? "pause" : "play_arrow"
            font.pointSize: 14
        }
    }
}
