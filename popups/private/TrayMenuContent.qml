pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

import "../../widgets" as Widgets

StackView {
    id: root

    required property QsMenuHandle menuHandle

    signal closeRequested

    pushEnter: NoAnim {}
    pushExit: NoAnim {}
    popEnter: NoAnim {}
    popExit: NoAnim {}

    initialItem: SubMenu {
        handle: root.menuHandle
    }

    component SubMenu: ColumnLayout {
        id: submenu
        required property QsMenuHandle handle
        property bool isSubMenu: false
        property bool shown: false
        opacity: shown ? 1 : 0

        Component.onCompleted: shown = true
        StackView.onActivating: shown = true
        StackView.onDeactivating: shown = false
        StackView.onRemoved: destroy()

        QsMenuOpener {
            id: menuOpener
            menu: submenu.handle
        }

        spacing: 2

        Loader {
            Layout.fillWidth: true
            visible: submenu.isSubMenu
            active: visible
            sourceComponent: Widgets.MenuButton {
                id: backButton
                implicitWidth: contentItem.implicitWidth + horizontalPadding * 2

                onClicked: {
                    root.pop();
                }

                contentItem: RowLayout {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        right: parent.right
                        leftMargin: backButton.horizontalPadding
                        rightMargin: backButton.horizontalPadding
                    }
                    spacing: 8
                    Widgets.MaterialIcon {
                        text: "chevron_left"
                        font.pointSize: 14
                    }
                    Widgets.Text {
                        Layout.fillWidth: true
                        text: "Back"
                    }
                }
            }
        }

        Repeater {
            id: menuEntriesRepeater
            property bool iconColumnNeeded: {
                for (let i = 0; i < menuOpener.children.values.length; i++) {
                    if (menuOpener.children.values[i].icon.length > 0)
                        return true;
                }
                return false;
            }
            property bool specialInteractionColumnNeeded: {
                for (let i = 0; i < menuOpener.children.values.length; i++) {
                    if (menuOpener.children.values[i].buttonType !== QsMenuButtonType.None)
                        return true;
                }
                return false;
            }

            model: menuOpener.children

            delegate: Loader {
                id: menuEntryLoader
                Layout.topMargin: modelData.isSeparator ? 4 : 0
                Layout.bottomMargin: modelData.isSeparator ? 4 : 0
                Layout.leftMargin: modelData.isSeparator ? 8 : 0
                Layout.rightMargin: modelData.isSeparator ? 8 : 0
                Layout.fillWidth: true

                required property QsMenuEntry modelData

                sourceComponent: modelData.isSeparator ? separatorComp : menuButtonComp
                onLoaded: {
                    if (modelData.isSeparator) {
                        return;
                    }
                    item.menuEntry = Qt.binding(() => {
                        return menuEntryLoader.modelData;
                    });
                    item.forceSpecialInteractionColumn = Qt.binding(() => {
                        return menuEntriesRepeater.specialInteractionColumnNeeded;
                    });
                    item.onDismiss.connect(() => {
                        root.closeRequested();
                    });
                    item.onOpenSubmenu.connect(handle => {
                        root.push(subMenuComponent.createObject(null, {
                            handle: handle,
                            isSubMenu: true
                        }));
                    });
                }
            }
        }
    }

    component NoAnim: Transition {
        NumberAnimation {
            duration: 0
        }
    }

    Component {
        id: menuButtonComp
        TrayMenuEntry {}
    }

    Component {
        id: separatorComp
        Widgets.MenuSeparator {}
    }

    Component {
        id: subMenuComponent
        SubMenu {}
    }
}
