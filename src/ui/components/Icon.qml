import QtQuick 2.0
import QtQuick.Controls 2.12

import "qrc:///ui/global/styles/"

Item {
    id: control

    property string icon
    property bool rotate: false
    property int duration: 1200
    property alias color: iconText.color
    property real size: AppStyle.font_normal

    implicitWidth: iconText.width
    implicitHeight: iconText.height

    Text {
        id: iconText

        text: control.icon
        color: AppStyle.defaultColor
        font.family: AppIcons.family
        font.pixelSize: control.size

        Behavior on width { NumberAnimation { duration: 400 } }
        Behavior on scale { NumberAnimation { duration: 100 } }
        RotationAnimation on rotation {
            running: control.rotate
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: control.duration
        }
        transitions: Transition {
            SequentialAnimation {
                NumberAnimation {
                    target: iconText
                    property: "scale"
                    // Go down 2 pixels in size.
                    to: 1 - 2 / iconText.width
                    duration: 120
                }
                NumberAnimation {
                    target: iconText
                    property: "scale"
                    to: 1
                    duration: 120
                }
            }
        }
    }
}

