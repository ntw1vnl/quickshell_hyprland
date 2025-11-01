import QtQuick
// import QtQuick.Controls
import QtQuick.Controls.Basic
import qs.config as Config

GroupBox {
    id: root

    property bool showBorder: true

    background: Rectangle {
        y: root.topPadding - root.bottomPadding
        width: parent.width
        height: parent.height - root.topPadding + root.bottomPadding
        color: "transparent"
        border.color: label.color
        border.width: root.showBorder ? 2 : 0
        radius: Config.Style.buttonRadius
        visible: root.showBorder
    }

    label: Label {
        width: root.availableWidth
        text: root.title
        color: root.enabled ? Config.Style.textColor : Config.Style.textDisabledColor
        elide: Text.ElideRight
        font.pointSize: Config.Style.titleFontPointSize
        font.bold: true
    }
}
