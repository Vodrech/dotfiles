pragma Singleton

import QtQuick

QtObject {
    property string time: ""

    property Timer timer: Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            time = Qt.formatDateTime(new Date(), "hh:mm:ss")
        }
    }

    Component.onCompleted: {
        time = Qt.formatDateTime(new Date(), "hh:mm:ss")
    }
}
