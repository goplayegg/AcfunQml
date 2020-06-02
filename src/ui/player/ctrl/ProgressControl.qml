import QtQuick 2.12
import QtQuick.Controls 2.12

Slider {
    id: control

    //property var slidePos: 0.0
    implicitHeight: 33
    horizontalPadding: 0
    from: 0.0
    to: 1.0
    value: 0.0
    hoverEnabled: true


    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4
        width: control.availableWidth
        height: implicitHeight
        radius: 2
        color: control.hovered?"#cccccb":"#bcbcb9"

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: control.hovered?"#c93164":"#ed5b8c"
            radius: 2
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 26
        implicitHeight: 26
        radius: 13
        color: control.hovered ? "#c93164" : "white"
        Image {
            anchors.centerIn: parent
            width: parent.width/2
            height: width
            source: ""
        }
    }
}
