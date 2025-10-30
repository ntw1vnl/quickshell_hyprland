pragma ComponentBehavior: Bound

import QtQuick
import qs.config as Config

Text {
    id: root

    property real fill
    property int grade: -25 // Colours.light ? 0 : -25

    renderType: Text.NativeRendering
    textFormat: Text.PlainText
    color: Config.Style.colors.text

    font.family: "Material Symbols Rounded"
    font.pointSize: 18
    font.variableAxes: ({
            FILL: root.fill.toFixed(1),
            GRAD: root.grade,
            opsz: fontInfo.pixelSize,
            wght: fontInfo.weight
        })
}
