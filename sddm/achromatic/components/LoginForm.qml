/*
 * Achromatic SDDM Theme - Login Form Component
 * Username/password input with minimal styling
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0

Item {
    id: root

    property color textColor: "#e0e0e0"
    property color textColorInactive: "#666666"
    property color inputBackground: "#111111"
    property color inputBorder: "#2a2a2a"
    property color inputBorderFocus: "#3a3a3a"
    property color buttonBackground: "#111111"
    property color buttonBackgroundHover: "#2a2a2a"
    property string fontFamily: "Noto Sans"
    property int fontSize: 10

    implicitWidth: formLayout.implicitWidth
    implicitHeight: formLayout.implicitHeight

    function focusUsername() {
        usernameField.forceActiveFocus()
    }

    ColumnLayout {
        id: formLayout
        anchors.fill: parent
        spacing: 16

        // Error message
        Text {
            id: errorMessage
            Layout.fillWidth: true
            Layout.preferredHeight: visible ? implicitHeight : 0

            font.family: root.fontFamily
            font.pixelSize: root.fontSize
            color: "#da4453"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            visible: text !== ""

            Connections {
                target: sddm
                function onLoginFailed() {
                    errorMessage.text = textConstants.loginFailed
                }
                function onLoginSucceeded() {
                    errorMessage.text = ""
                }
            }
        }

        // Username field
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            color: root.inputBackground
            border.color: usernameField.activeFocus ? root.inputBorderFocus : root.inputBorder
            border.width: 1
            radius: 0

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Text {
                    text: "USER"
                    font.family: root.fontFamily
                    font.pixelSize: root.fontSize
                    font.weight: Font.Medium
                    color: root.textColorInactive
                    Layout.preferredWidth: 50
                }

                TextInput {
                    id: usernameField
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    font.family: root.fontFamily
                    font.pixelSize: root.fontSize + 1
                    color: root.textColor
                    selectionColor: root.inputBorderFocus
                    selectedTextColor: root.textColor
                    verticalAlignment: TextInput.AlignVCenter
                    clip: true

                    text: userModel.lastUser

                    Keys.onReturnPressed: {
                        if (text !== "") {
                            passwordField.forceActiveFocus()
                        }
                    }
                    Keys.onEnterPressed: Keys.onReturnPressed(event)
                    Keys.onTabPressed: passwordField.forceActiveFocus()
                }
            }
        }

        // Password field
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            color: root.inputBackground
            border.color: passwordField.activeFocus ? root.inputBorderFocus : root.inputBorder
            border.width: 1
            radius: 0

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Text {
                    text: "PASS"
                    font.family: root.fontFamily
                    font.pixelSize: root.fontSize
                    font.weight: Font.Medium
                    color: root.textColorInactive
                    Layout.preferredWidth: 50
                }

                TextInput {
                    id: passwordField
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    font.family: root.fontFamily
                    font.pixelSize: root.fontSize + 1
                    color: root.textColor
                    selectionColor: root.inputBorderFocus
                    selectedTextColor: root.textColor
                    verticalAlignment: TextInput.AlignVCenter
                    echoMode: TextInput.Password
                    clip: true

                    Keys.onReturnPressed: doLogin()
                    Keys.onEnterPressed: Keys.onReturnPressed(event)
                    Keys.onTabPressed: usernameField.forceActiveFocus()
                }
            }
        }

        // Login button
        Rectangle {
            id: loginButton
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            color: loginButtonArea.containsMouse ? root.buttonBackgroundHover : root.buttonBackground
            border.color: root.inputBorder
            border.width: 1
            radius: 0

            Text {
                anchors.centerIn: parent
                text: "LOGIN"
                font.family: root.fontFamily
                font.pixelSize: root.fontSize
                font.weight: Font.Medium
                color: root.textColor
            }

            MouseArea {
                id: loginButtonArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: doLogin()
            }

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
    }

    TextConstants {
        id: textConstants
    }

    function doLogin() {
        if (usernameField.text === "") {
            usernameField.forceActiveFocus()
            return
        }
        if (passwordField.text === "") {
            passwordField.forceActiveFocus()
            return
        }

        errorMessage.text = ""
        sddm.login(usernameField.text, passwordField.text, sessionModel.lastIndex)
    }
}

