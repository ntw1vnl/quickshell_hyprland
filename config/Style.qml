pragma Singleton

import QtQuick
import Quickshell.Io

import "../utils/Utils.js" as UtilsJS

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

    // Themes

    function getThemeByName(name: string, customThemes: list<var>): Theme {
        let theme;
        if (customThemes) {
            let jsonThemeObj = customThemes.find(theme => theme.name == name);
            theme = UtilsJS.createThemeObject(jsonThemeObj, root);
        }
        if (!theme) {
            theme = defaultThemes.find(theme => theme.name == name);
        }
        return theme ?? defaultTheme;
    }

    readonly property Theme defaultTheme: catpuccinMochaTheme

    readonly property list<Theme> defaultThemes: [catpuccinMochaTheme, catpuccinLatteTheme]

    readonly property Theme catpuccinMochaTheme: Theme {
        name: "catpuccin-mocha"
        palette: ColorPalette {
            bgDark: mocha.crust
            bg: mocha.mantle
            bgLight: mocha.surface1
            text: mocha.text
            textMuted: mocha.subtext1
            textDisabled: mocha.subtext0
            textDark: mocha.crust

            green: mocha.green
            yellow: mocha.peach
            red: mocha.red

            accent: mocha.maroon

            readonly property QtObject mocha: QtObject {
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
    }

    readonly property Theme catpuccinLatteTheme: Theme {
        name: "catpuccin-latte"
        palette: ColorPalette {
            bgDark: latte.crust
            bg: latte.mantle
            bgLight: latte.surface1
            text: latte.text
            textMuted: latte.subtext1
            textDisabled: latte.subtext0
            textDark: latte.crust

            green: latte.green
            yellow: latte.peach
            red: latte.red

            accent: latte.maroon

            readonly property QtObject latte: QtObject {
                readonly property color rosewater: "#dc8a78"
                readonly property color flamingo: "#dd7878"
                readonly property color pink: "#ea76cb"
                readonly property color mauve: "#8839ef"
                readonly property color red: "#d20f39"
                readonly property color maroon: "#e64553"
                readonly property color peach: "#fe640b"
                readonly property color yellow: "#df8e1d"
                readonly property color green: "#40a02b"
                readonly property color teal: "#179299"
                readonly property color sky: "#04a5e5"
                readonly property color sapphire: "#209fb5"
                readonly property color blue: "#1e66f5"
                readonly property color lavender: "#7287fd"
                readonly property color text: "#4c4f69"
                readonly property color subtext1: "#5c5f77"
                readonly property color subtext0: "#6c6f85"
                readonly property color overlay2: "#7c7f93"
                readonly property color overlay1: "#8c8fa1"
                readonly property color overlay0: "#9ca0b0"
                readonly property color surface2: "#acb0be"
                readonly property color surface1: "#bcc0cc"
                readonly property color surface0: "#ccd0da"
                readonly property color base: "#eff1f5"
                readonly property color mantle: "#e6e9ef"
                readonly property color crust: "#dce0e8"
            }
        }
    }
}
