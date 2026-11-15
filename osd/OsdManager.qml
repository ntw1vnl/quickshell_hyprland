pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

import qs.services as Services
import qs.utils as Utils
import qs.widgets as Widgets

QtObject {
    id: root

    required property OsdPopup popup

    property Connections audioServiceConnections: Connections {
        target: Services.AudioService

        function onDisplayOsdRequested() {
            root.popup.contentLoaderSource = "OsdVolume.qml";
            root.popup.display();
        }
    }
}
