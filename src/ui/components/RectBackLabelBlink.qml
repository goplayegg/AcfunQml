import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

RectBackLabel {
    property alias blink: anim.running
    ColorAnimation on clr {
        id: anim
        from: AppStyle.secondForeColor
        to: AppStyle.backgroundColor
        duration: 2000
        loops: Animation.Infinite
        running: false
    }
}
