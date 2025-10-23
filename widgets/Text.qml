import QtQuick

import qs.style as Style

Text {
  id: root

  property bool highlight: false
  property color highlightColor: Style.Colors.pink
  property color regularColor: Style.Colors.text

  color: highlight ? highlightColor : regularColor
  font.bold: true
}
