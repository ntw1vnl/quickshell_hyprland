pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.config as Config
import qs.widgets as Widgets
import qs.utils as Utils

Widgets.Popup {
    id: root

    content: Item {
        implicitHeight: columnLayout.implicitHeight
        implicitWidth: 600

        ColumnLayout {
            id: columnLayout
            anchors.fill: parent

            Widgets.GroupBox {
                title: "Buttons"
                Row {
                    anchors.fill: parent
                    spacing: 20
                    Widgets.Button {
                        text: "Extra large"
                        size: Config.Style.Size.ExtraLarge
                    }
                    Widgets.Button {
                        text: "Large"
                        size: Config.Style.Size.Large
                    }
                    Widgets.Button {
                        text: "Medium"
                        size: Config.Style.Size.Medium
                    }
                    Widgets.Button {
                        text: "Small"
                        size: Config.Style.Size.Small
                    }
                    Widgets.Button {
                        text: "Extra Small"
                        size: Config.Style.Size.ExtraSmall
                    }
                }
            }

            Widgets.GroupBox {
                showBorder: false
                title: "Disabled Buttons"
                Row {
                    anchors.fill: parent
                    spacing: 20
                    Widgets.Button {
                        text: "Extra large"
                        size: Config.Style.Size.ExtraLarge
                        enabled: false
                    }
                    Widgets.Button {
                        text: "Large"
                        size: Config.Style.Size.Large
                        enabled: false
                    }
                    Widgets.Button {
                        text: "Medium"
                        size: Config.Style.Size.Medium
                        enabled: false
                    }
                    Widgets.Button {
                        text: "Small"
                        size: Config.Style.Size.Small
                        enabled: false
                    }
                    Widgets.Button {
                        text: "Extra Small"
                        size: Config.Style.Size.ExtraSmall
                        enabled: false
                    }
                }
            }
        }
    }
}
