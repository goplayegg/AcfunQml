import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import "qrc:///ui/global/libraries/functions.js" as FUN

RowLayout {
    id: control
    spacing: 4
    height: colText.height

    property var infoJs: ({})

    Column {
        Layout.topMargin: 6
        Layout.alignment: Qt.AlignTop
        width: 30
        Image {
            height: 14
            width: height
            sourceSize: Qt.size(width, height)
            source: "qrc:/assets/img/common/cmt1.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            width: parent.width
            font.pixelSize: AppStyle.font_xsmal
            font.family: AppStyle.fontNameMain
            horizontalAlignment: Text.AlignHCenter
            text: infoJs.commentCountTenThousandShow
        }
    }
    Column {
        id: colText
        spacing: 4
        Layout.fillWidth: true

        Text {
            anchors.left: parent.left
            anchors.right: parent.right
            font.pointSize: AppStyle.font_normal
            font.family: AppStyle.fontNameMain
            font.bold: true
            wrapMode: Text.WordWrap
            text: infoJs.contentTitle
        }
        Row {
            spacing: 6
            anchors.left: parent.left
            anchors.right: parent.right

            Text {
                font.pixelSize: AppStyle.font_smal
                font.family: AppStyle.fontNameMain
                text: {
                    var d = new Date()
                    d.setTime(infoJs.contributeTime)
                    return FUN.fmtTime(d, "yyyy-MM-dd")
                }
            }

            Text {
                font.pixelSize: AppStyle.font_smal
                font.family: AppStyle.fontNameMain
                text: qsTr("%1 viewed").arg(infoJs.viewCountShow)
            }

            Text {
                font.pixelSize: AppStyle.font_smal
                font.family: AppStyle.fontNameMain
                text: infoJs.channelName
            }
        }
    }
}
