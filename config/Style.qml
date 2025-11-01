pragma Singleton

import QtQuick

QtObject {
    id: root

    // Sizes

    enum Size {
        ExtraLarge,
        Large,
        Medium,
        Small,
        ExtraSmall
    }

    function buttonSize(size) {
        switch (size) {
        case Style.Size.ExtraLarge:
            return 48;
        case Style.Size.Large:
            return 36;
        case Style.Size.Medium:
            return 28;
        case Style.Size.Small:
            return 20;
        case Style.Size.ExtraSmall:
            return 16;
        }
        return 0;
    }

    function fontPointSize(size) {
        switch (size) {
        case Style.Size.ExtraLarge:
            return 10;
        case Style.Size.Large:
            return 9;
        case Style.Size.Medium:
            return 9;
        case Style.Size.Small:
            return 8;
        case Style.Size.ExtraSmall:
            return 7;
        }
        return 0;
    }

    property real buttonRadius: 4
    property real titleFontPointSize: 11

    // Colors

    //TODO: use https://doc.qt.io/qt-6/qml-qtquick-palette.html ?

    property color textColor: colors.text
    property color textDisabledColor: colors.surface2
    property color accentColor: colors.maroon
    property color controlEnabledBgColor: colors.text
    property color controlDisabledBgColor: colors.surface2

    property var colors: QtObject {
        // catpuccin mocha colors : https://catppuccin.com/palette/
        readonly property color rosewater: "#f5e0dc"
        readonly property color flamingo: "#f2cdcd"
        readonly property color pink: "#f5c2e7"
        readonly property color mauve: "#cba6f7"
        readonly property color red: "#f38ba8"
        readonly property color maroon: "#eba0ac"
        readonly property color peach: "#fab387"
        readonly property color yellow: "#f9e2af"
        readonly property color green: "#a6e3a1"
        readonly property color teal: "#94e2d5"
        readonly property color sky: "#89dceb"
        readonly property color sapphire: "#74c7ec"
        readonly property color blue: "#89b4fa"
        readonly property color lavender: "#b4befe"
        readonly property color text: "#cdd6f4"
        readonly property color subtext1: "#bac2de"
        readonly property color subtext0: "#a6adc8"
        readonly property color overlay2: "#9399b2"
        readonly property color overlay1: "#7f849c"
        readonly property color overlay0: "#6c7086"
        readonly property color surface2: "#585b70"
        readonly property color surface1: "#45475a"
        readonly property color surface0: "#313244"
        readonly property color base: "#1e1e2e"
        readonly property color mantle: "#181825"
        readonly property color crust: "#11111b"
    }
}
