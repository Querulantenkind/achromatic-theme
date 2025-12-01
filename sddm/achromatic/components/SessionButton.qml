/*
 * Achromatic SDDM Theme - Session Button Component
 * Desktop session selector dropdown
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0

Item {
    id: root

    property color textColor: "#e0e0e0"
    property color textColorInactive: "#666666"
    property color buttonBackground: "#111111"
    property color buttonBackgroundHover: "#2a2a2a"
    property string fontFamily: "Noto Sans"
    property int fontSize: 10

    implicitWidth: sessionButton.implicitWidth
    implicitHeight: sessionButton.implicitHeight

    Rectangle {
        id: sessionButton
        implicitWidth: sessionRow.implicitWidth + 24
        implicitHeight: 36
        color: sessionArea.containsMouse || sessionPopup.visible ? root.buttonBackgroundHover : root.buttonBackground
        border.color: root.buttonBackground
        border.width: 1
        radius: 0

        Row {
            id: sessionRow
            anchors.centerIn: parent
            spacing: 8

            Text {
                text: "SESSION:"
                font.family: root.fontFamily
                font.pixelSize: root.fontSize
                font.weight: Font.Medium
                color: root.textColorInactive
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: sessionText
                text: sessionModel.data(sessionModel.index(sessionModel.lastIndex, 0), Qt.DisplayRole) || "Unknown"
                font.family: root.fontFamily
                font.pixelSize: root.fontSize
                color: root.textColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: sessionPopup.visible ? "\u25B2" : "\u25BC"
                font.family: root.fontFamily
                font.pixelSize: root.fontSize - 2
                color: root.textColorInactive
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        MouseArea {
            id: sessionArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                if (sessionPopup.visible) {
                    sessionPopup.close()
                } else {
                    sessionPopup.open()
                }
            }
        }

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }

    // Session dropdown popup
    Popup {
        id: sessionPopup
        x: 0
        y: -contentHeight - 4
        width: sessionButton.width
        padding: 0

        background: Rectangle {
            color: root.buttonBackground
            border.color: root.buttonBackgroundHover
            border.width: 1
        }

        contentItem: ListView {
            id: sessionList
            implicitHeight: Math.min(contentHeight, 200)
            model: sessionModel
            clip: true
            currentIndex: sessionModel.lastIndex

            delegate: Rectangle {
                width: sessionList.width
                height: 36
                color: sessionItemArea.containsMouse || index === sessionList.currentIndex ? root.buttonBackgroundHover : "transparent"

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    text: model.name
                    font.family: root.fontFamily
                    font.pixelSize: root.fontSize
                    color: index === sessionList.currentIndex ? root.textColor : root.textColorInactive
                }

                MouseArea {
                    id: sessionItemArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        sessionList.currentIndex = index
                        sessionText.text = model.name
                        sessionPopup.close()
                    }
                }

                Behavior on color {
                    ColorAnimation { duration: 100 }
                }
            }
        }
    }
}

