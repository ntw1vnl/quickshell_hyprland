pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../../config" as Config
import "../../widgets" as Widgets

Widgets.MenuButton {
    id: root

    size: Config.Style.Size.ExtraSmall

    property QsMenuEntry menuEntry
    property bool forceSpecialInteractionColumn: false

    signal dismiss
    signal openSubmenu(handle: QsMenuHandle)

    readonly property bool hasIcon: menuEntry?.icon.length > 0
    readonly property bool forceIconColumn: false
    readonly property bool hasSpecialInteraction: menuEntry?.buttonType !== QsMenuButtonType.None

    onReleased: {
        if (menuEntry.hasChildren) {
            root.openSubmenu(root.menuEntry);
            return;
        }
        menuEntry.triggered();
        root.dismiss();
    }

    contentItem: RowLayout {
        id: contentItem
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: root.horizontalPadding
            rightMargin: root.horizontalPadding
        }
        spacing: 8

        // Interaction: checkbox or radio button
        Item {
            visible: root.hasSpecialInteraction || root.forceSpecialInteractionColumn
            implicitWidth: 20
            implicitHeight: 20

            Loader {
                anchors.fill: parent
                active: root.menuEntry?.buttonType === QsMenuButtonType.RadioButton

                sourceComponent: RadioButton {
                    enabled: false
                    padding: 0
                    checked: root.menuEntry.checkState === Qt.Checked
                }
            }

            Loader {
                anchors.fill: parent
                active: root.menuEntry?.buttonType === QsMenuButtonType.CheckBox && root.menuEntry?.checkState !== Qt.Unchecked

                sourceComponent: Widgets.MaterialIcon {
                    text: root.menuEntry?.checkState === Qt.PartiallyChecked ? "check_indeterminate_small" : "check"
                }
            }
        }

        // Button icon
        Item {
            visible: root.hasIcon || root.forceIconColumn
            implicitWidth: 20
            implicitHeight: 20

            Loader {
                anchors.centerIn: parent
                active: root.menuEntry?.icon.length > 0
                sourceComponent: IconImage {
                    asynchronous: true
                    source: root.menuEntry?.icon ?? ""
                    implicitSize: 18
                    mipmap: true
                }
            }
        }

        Widgets.Text {
            id: label
            text: root.menuEntry?.text ?? ""
            Layout.fillWidth: true
        }

        Loader {
            active: root.menuEntry?.hasChildren ?? false

            sourceComponent: Widgets.MaterialIcon {
                text: "chevron_right"
                font.pointSize: 14
            }
        }
    }
}
