import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

WrapperItem {
    id: root

    property list<Item> items

    property QtObject internal: QtObject {
        id: internal
        property int currentIndex: 0
        function getNextIndex() {
            if (currentIndex + 1 == root.items.length) {
                return 0;
            }
            return currentIndex + 1;
        }
    }

    function displayNext() {
        internal.currentIndex = internal.getNextIndex();
    }

    child: items[internal.currentIndex]

    TapHandler {
        onTapped: {
            root.displayNext();
        }
    }
}
