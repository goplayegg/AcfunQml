import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

Row {
    id: control
    spacing: 4
    leftPadding: 10
    property string url: ""
    property string text: ""
    property string prefix: "•"
    Label {
        id: laPrefix
        height: laText.height
        text: prefix
        font.weight: Font.Bold
        font.pixelSize: AppStyle.font_large
        font.family: AppStyle.fontNameMain
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Label {
        id: laText
        text: "<a href=\"" + url + "\">" + control.text + "</a>"
        font.pixelSize: AppStyle.font_large
        font.family: AppStyle.fontNameMain
        onLinkActivated: Qt.openUrlExternally(link)
    }
}
