import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

Slider {
    id: control

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
        color: control.hovered?Qt.lighter(AppStyle.thirdBkgroundColor):AppStyle.thirdBkgroundColor

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: control.hovered?Qt.lighter(AppStyle.primaryColor):AppStyle.primaryColor
            radius: 2
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 26
        implicitHeight: 26
        radius: 13
        color: control.hovered?AppStyle.primaryColor:AppStyle.backgroundColor
        Label {
            anchors.centerIn: parent
            text: AppIcons.mdi_fan
            font.family: AppIcons.family
            font.pixelSize: 20
            color: AppStyle.defaultColor
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            NumberAnimation on rotation {
                id: anim
                from: 0
                to: 360*3
                duration: 3000
                easing.type: Easing.OutCubic
            }
        }
    }

    onPressedChanged: {
        if(pressed)
            anim.restart()
    }
}
