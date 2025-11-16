pragma Singleton

import QtQuick

QtObject {
    id: root

    property var battery: QtObject {
        property real criticalTreshold: 0.10
        property real warningTreshold: 0.25
    }
}
