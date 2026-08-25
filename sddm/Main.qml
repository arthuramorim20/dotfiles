import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Effects

Item {
    id: root

    width: Screen.width
    height: Screen.height

    property bool authenticationFailed: false
    property int selectedSession: sessionModel.lastIndex

    function login() {
        authenticationFailed = false
        sddm.login(username.text, password.text, selectedSession)
    }

    Image {
        anchors.fill: parent
        source: config.Background
        fillMode: Image.PreserveAspectCrop
        asynchronous: false
        cache: true
        mipmap: true
    }

    Text {
        anchors.top: parent.top
        anchors.topMargin: Number(config.DateTopMargin)
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#DBFFFFFF"
        font.family: config.Font
        font.pixelSize: 14
        text: Qt.formatDateTime(clock.now, "dddd, MMMM d")
        renderType: Text.NativeRendering
    }

    Text {
        anchors.top: parent.top
        anchors.topMargin: Number(config.TimeTopMargin)
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#F0FFFFFF"
        font.family: config.Font
        font.pixelSize: 90
        font.weight: Font.ExtraLight
        text: Qt.formatDateTime(clock.now, "h:mm")
        renderType: Text.NativeRendering
    }

    Item {
        id: avatar

        width: 68
        height: 68
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Number(config.AvatarBottomMargin)
        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            id: avatarSource

            anchors.fill: parent
            source: config.Avatar
            fillMode: Image.PreserveAspectCrop
            visible: false
        }

        Rectangle {
            id: avatarMask

            anchors.fill: parent
            radius: width / 2
            visible: false
            layer.enabled: true
        }

        MultiEffect {
            anchors.fill: parent
            source: avatarSource
            maskEnabled: true
            maskSource: avatarMask
        }
    }

    TextInput {
        id: username

        width: 280
        height: 28
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Number(config.UserBottomMargin)
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#EBFFFFFF"
        font.family: config.Font
        font.pixelSize: 16
        horizontalAlignment: TextInput.AlignHCenter
        verticalAlignment: TextInput.AlignVCenter
        text: userModel.lastUser !== "" ? userModel.lastUser : config.FallbackUser
        selectByMouse: true
        renderType: Text.NativeRendering
        KeyNavigation.down: password
        onAccepted: password.forceActiveFocus()
    }

    TextField {
        id: password

        width: 280
        height: 46
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Number(config.PasswordBottomMargin)
        anchors.horizontalCenter: parent.horizontalCenter
        focus: true
        color: "#F2FFFFFF"
        placeholderTextColor: authenticationFailed ? "#FFFF8A80" : "#CCFFFFFF"
        placeholderText: authenticationFailed ? qsTr("Authentication failed") : qsTr("Enter Password")
        echoMode: TextInput.Password
        passwordCharacter: "•"
        selectByMouse: true
        horizontalAlignment: TextInput.AlignHCenter
        verticalAlignment: TextInput.AlignVCenter
        font.family: config.Font
        font.pixelSize: 15
        renderType: Text.NativeRendering
        onTextChanged: {
            if (text !== "")
                authenticationFailed = false
        }
        onAccepted: root.login()

        background: Rectangle {
            radius: 23
            color: "#38FFFFFF"
            border.width: 1
            border.color: password.activeFocus ? "#8AFFFFFF" : "#52FFFFFF"

            Behavior on border.color {
                ColorAnimation { duration: 120 }
            }
        }
    }

    Timer {
        id: clock

        property date now: new Date()

        interval: 1000
        running: true
        repeat: true
        onTriggered: now = new Date()
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            root.authenticationFailed = true
            password.text = ""
            password.forceActiveFocus()
        }
    }
}
