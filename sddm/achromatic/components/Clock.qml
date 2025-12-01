/*
 * Achromatic SDDM Theme - Clock Component
 * Displays time and date in monospace font
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: root

    property color textColor: "#e0e0e0"
    property color textColorInactive: "#666666"
    property string clockFontFamily: "monospace"
    property int clockFontSize: 48
    property string fontFamily: "Noto Sans"
    property int fontSize: 10

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    ColumnLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 8

        // Time display
        Text {
            id: timeText
            Layout.alignment: Qt.AlignHCenter

            font.family: root.clockFontFamily
            font.pixelSize: root.clockFontSize
            font.weight: Font.Light
            color: root.textColor
            renderType: Text.NativeRendering

            function updateTime() {
                var now = new Date()
                var hours = now.getHours().toString().padStart(2, '0')
                var minutes = now.getMinutes().toString().padStart(2, '0')
                text = hours + ":" + minutes
            }
        }

        // Date display
        Text {
            id: dateText
            Layout.alignment: Qt.AlignHCenter

            font.family: root.fontFamily
            font.pixelSize: root.fontSize + 2
            font.weight: Font.Normal
            color: root.textColorInactive
            renderType: Text.NativeRendering

            function updateDate() {
                var now = new Date()
                // Use Qt.formatDate for reliable cross-platform date formatting
                text = Qt.formatDate(now, "dddd, MMMM d, yyyy")
            }
        }
    }

    // Timer to update clock every second
    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            timeText.updateTime()
            dateText.updateDate()
        }
    }

    Component.onCompleted: {
        timeText.updateTime()
        dateText.updateDate()
    }
}

