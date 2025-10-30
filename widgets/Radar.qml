import QtQuick

Rectangle {
    id: root

    implicitWidth: 400
    implicitHeight: 400

    ShaderEffect {
        id: effect
        anchors.fill: parent
        property real angle
        fragmentShader: "radar.frag.qsb"

        NumberAnimation on angle {
            running: true
            // easing.type: Easing.OutBounce
            duration: 3000
            loops: Animation.Infinite
            from: 0
            to: 360
        }
    }
}
