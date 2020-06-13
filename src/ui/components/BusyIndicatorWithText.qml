import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import "qrc:///ui/global/styles/"

Rectangle {
    color: AppStyle.secondBkgroundColor
    property alias text: msg.text
    property alias running: anim.running
    width: 180
    height: 180
    z: AppStyle.busyZ

    Item {
        anchors.fill: parent
        anchors.margins: 35
        Label {
            id:msg
            font.pointSize: 12
            anchors.bottom: parent.bottom
            width: parent.width
            wrapMode: Text.Wrap
        }

        Rectangle {
            id: rect
            width: 64
            height: 64
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            color: Qt.rgba(0, 0, 0, 0)
            radius: width / 2
            border.width: width / 8
            visible: false
        }

        ConicalGradient {
            anchors.fill: rect
            gradient: Gradient {
                GradientStop { position: 0.0; color: AppStyle.backgroundColor }
                GradientStop { position: 1.0; color: AppStyle.primaryColor }
            }
            source: rect

            Rectangle {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: rect.border.width
                height: width
                radius: width / 2
                color: AppStyle.primaryColor
            }

            RotationAnimation on rotation {
                id: anim
                from: 0
                to: 360
                duration: 300
                loops: Animation.Infinite
                running: false
            }
        }
    }
}
