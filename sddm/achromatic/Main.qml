/*
 * Achromatic SDDM Theme
 * Pure Monochrome Login Screen for KDE Plasma 6
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0

import "components"

Rectangle {
    id: root

    // Theme configuration
    property color backgroundColor: config.background || "#0a0a0a"
    property color textColor: config.textColor || "#e0e0e0"
    property color textColorInactive: config.textColorInactive || "#666666"
    property color inputBackground: config.inputBackground || "#111111"
    property color inputBorder: config.inputBorder || "#2a2a2a"
    property color inputBorderFocus: config.inputBorderFocus || "#3a3a3a"
    property color buttonBackground: config.buttonBackground || "#111111"
    property color buttonBackgroundHover: config.buttonBackgroundHover || "#2a2a2a"
    property string fontFamily: config.font || "Noto Sans"
    property int fontSize: parseInt(config.fontSize) || 10
    property string clockFontFamily: config.clockFont || "monospace"
    property int clockFontSize: parseInt(config.clockFontSize) || 48
    property int formWidth: parseInt(config.formWidth) || 320

    width: 640
    height: 480
    color: backgroundColor

    // Background - solid color or image
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: config.background && config.background.charAt(0) === '/' ? config.background : ""
        fillMode: Image.PreserveAspectCrop
        visible: source !== ""
    }

    // Solid background fallback
    Rectangle {
        anchors.fill: parent
        color: backgroundColor
        visible: backgroundImage.source === ""
    }

    // Main content layout
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 0

        // Top section - Clock
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.35

            Clock {
                id: clock
                anchors.centerIn: parent
                textColor: root.textColor
                textColorInactive: root.textColorInactive
                clockFontFamily: root.clockFontFamily
                clockFontSize: root.clockFontSize
                fontFamily: root.fontFamily
                fontSize: root.fontSize
            }
        }

        // Center section - Login Form
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            LoginForm {
                id: loginForm
                anchors.centerIn: parent
                width: root.formWidth

                textColor: root.textColor
                textColorInactive: root.textColorInactive
                inputBackground: root.inputBackground
                inputBorder: root.inputBorder
                inputBorderFocus: root.inputBorderFocus
                buttonBackground: root.buttonBackground
                buttonBackgroundHover: root.buttonBackgroundHover
                fontFamily: root.fontFamily
                fontSize: root.fontSize
            }
        }

        // Bottom section - Session and Power buttons
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 60

            RowLayout {
                anchors.fill: parent
                spacing: 20

                // Session selector
                SessionButton {
                    id: sessionButton
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                    textColor: root.textColor
                    textColorInactive: root.textColorInactive
                    buttonBackground: root.buttonBackground
                    buttonBackgroundHover: root.buttonBackgroundHover
                    fontFamily: root.fontFamily
                    fontSize: root.fontSize
                }

                Item {
                    Layout.fillWidth: true
                }

                // Power buttons
                Row {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    spacing: 10

                    // Suspend button
                    ImageButton {
                        id: suspendButton
                        width: 32
                        height: 32
                        source: "images/suspend.svg"
                        visible: sddm.canSuspend

                        onClicked: sddm.suspend()

                        Rectangle {
                            anchors.fill: parent
                            color: parent.containsMouse ? root.buttonBackgroundHover : "transparent"
                            radius: 4
                            z: -1
                        }
                    }

                    // Reboot button
                    ImageButton {
                        id: rebootButton
                        width: 32
                        height: 32
                        source: "images/reboot.svg"
                        visible: sddm.canReboot

                        onClicked: sddm.reboot()

                        Rectangle {
                            anchors.fill: parent
                            color: parent.containsMouse ? root.buttonBackgroundHover : "transparent"
                            radius: 4
                            z: -1
                        }
                    }

                    // Shutdown button
                    ImageButton {
                        id: shutdownButton
                        width: 32
                        height: 32
                        source: "images/shutdown.svg"
                        visible: sddm.canPowerOff

                        onClicked: sddm.powerOff()

                        Rectangle {
                            anchors.fill: parent
                            color: parent.containsMouse ? root.buttonBackgroundHover : "transparent"
                            radius: 4
                            z: -1
                        }
                    }
                }
            }
        }
    }

    // Keyboard focus handling
    Component.onCompleted: {
        loginForm.focusUsername()
    }
}

