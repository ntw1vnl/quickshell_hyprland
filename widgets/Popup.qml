import QtQuick
import Quickshell
import qs.config as Config

PopupWindow {
    id: root

    required property Item anchorItem

    property alias content: contentLoader.sourceComponent
    property real spacing: 8
    property real padding: 16

    anchor.item: anchorItem
    anchor.rect.x: (anchorItem.width - width) / 2
    anchor.rect.y: anchorItem.height + spacing

    implicitWidth: bg.implicitWidth
    implicitHeight: bg.implicitHeight

    visible: true
    color: "transparent"

    Rectangle {
        id: bg
        implicitWidth: contentLoader.sourceComponent != undefined ? contentLoader.implicitWidth + root.padding * 2 : 400
        implicitHeight: contentLoader.sourceComponent != undefined ? contentLoader.implicitHeight + root.padding * 2 : 200
        color: Config.Style.colors.crust
        radius: 10
        Loader {
            id: contentLoader
            anchors.centerIn: parent
        }
    }
}
