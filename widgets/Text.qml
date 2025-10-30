import QtQuick

import qs.config as Config

Text {
    id: root

    property bool highlight: false
    property color highlightColor: Config.Style.textDisabledColor
    property color regularColor: Config.Style.textColor

    color: highlight ? highlightColor : regularColor
    font.bold: true
}
