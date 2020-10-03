import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

Label {
    id: control
    property color clr: AppStyle.thirdForeColor
    property alias blink: anim.running
    background: Rectangle{
        id: bk
        color: "transparent"
        border.color: clr
        border.width: 1
        radius: 4
    }
    topPadding: 2
    bottomPadding: 2
    leftPadding: 4
    rightPadding: 4
    verticalAlignment: Text.AlignVCenter
    font.pixelSize: AppStyle.font_normal
    font.family: AppStyle.fontNameMain
    font.weight: Font.Normal
    color: clr
    ColorAnimation on clr {
        id: anim
        from: AppStyle.secondForeColor
        to: AppStyle.backgroundColor
        duration: 2000
        loops: Animation.Infinite
        running: false
    }
}
