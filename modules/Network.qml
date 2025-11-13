pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets

import qs.config as Config
import qs.widgets as Widgets
import qs.services as Services

Widgets.Chip {
    id: root

    padding: 4

        id: chip
        property string name
        height: root.height - root.padding * 2
        color: Config.Style.colors.green
        content: Row {
            id: row
            spacing: 4

            Widgets.Text {
                id: text
                anchors.verticalCenter: parent.verticalCenter
                color: Config.Style.colors.base
                // text: "🇩🇪"
                font.pointSize: 10
            }
        }
    }

    content: Row {
        spacing: 4

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            text: Services.NetworkManager.icon
            font.pointSize: 16
        }

            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
