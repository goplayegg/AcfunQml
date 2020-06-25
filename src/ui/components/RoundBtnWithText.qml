import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"

Row {
    id: root
    spacing: 8
    signal clicked()
    property alias icon: btn.img
    property alias iconChecked: btn.imgChecked
    property alias text: lab.text
    property alias customChecked: btn.customChecked
    RoundImgBtn {
        id: btn
        onClicked: root.clicked()
    }
    Label {
        id: lab
        height: btn.height
        font.weight: Font.Bold
        font.pixelSize: AppStyle.font_large
        font.family: AppStyle.fontNameMain
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
