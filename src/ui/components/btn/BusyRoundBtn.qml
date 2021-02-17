import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/btn"

RoundButton {
    id: control
    icon.name: AppIcons.mdi_refresh
    tooltip: qsTr("refresh")
    size: 40
    textColor: AppStyle.accentColor
    onClicked: anim.running = true

    Rectangle {
        id: rect
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0)
        radius: width / 2
        border.width: 3
        visible: false
    }

    ConicalGradient {
        visible: anim.running
        anchors.fill: rect
        gradient: Gradient {
            GradientStop { position: 0.0; color: AppStyle.backgroundColor }
            GradientStop { position: 1.0; color: control.textColor }
        }
        source: rect

        Rectangle {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: rect.border.width
            height: width
            radius: width / 2
            color: control.textColor
        }

        RotationAnimation on rotation {
            id: anim
            from: 0
            to: 360*3
            duration: 1500
            running: false
        }
    }
}
