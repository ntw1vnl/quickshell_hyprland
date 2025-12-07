import QtQuick

import "../config" as Config

Text {
    id: root

    property int size: Config.Style.Size.Medium
    property bool highlight: false
    property color highlightColor: Config.Settings.colors.textDisabled
    property color regularColor: Config.Settings.colors.text

    color: highlight ? highlightColor : regularColor
    font.bold: true
    font.pointSize: Config.Style.fontPointSize(root.size)
    verticalAlignment: Text.AlignVCenter
}
