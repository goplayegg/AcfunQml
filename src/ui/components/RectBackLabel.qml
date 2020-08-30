import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

Label {
    background: Rectangle{
        color: "transparent"
        border.color: AppStyle.thirdForeColor
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
    color: AppStyle.thirdForeColor
}
