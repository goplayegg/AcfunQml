import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import "qrc:///ui/global/libraries/functions.js" as FUN

Item {
    height: control.height
    property var infoJs: ({})
    RowLayout {
        id: control
        spacing: 4
        anchors.left: parent.left
        anchors.right: parent.right
        height: colText.height

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
                text: infoJs.commentCountTenThousandShow?infoJs.commentCountTenThousandShow:infoJs.visit.comments
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
                text: infoJs.title?infoJs.title:infoJs.contentTitle
            }
            Row {
                spacing: 6
                anchors.left: parent.left
                anchors.right: parent.right

                RoundImage {
                    id: imgUser
                    visible: infoJs.user !== undefined
                    size: 24
                    source: visible?infoJs.user.img:""
                }

                Text {
                    height: imgUser.visible? parent.height: undefined
                    verticalAlignment: Text.AlignVCenter
                    visible: infoJs.user !== undefined
                    font.pixelSize: AppStyle.font_smal
                    font.family: AppStyle.fontNameMain
                    text: visible?infoJs.user.name:""
                }

                Text {
                    height: imgUser.visible? parent.height: undefined
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: AppStyle.font_smal
                    font.family: AppStyle.fontNameMain
                    text: {
                        var d = new Date()
                        d.setTime(infoJs.time?infoJs.time:infoJs.contributeTime)
                        return FUN.fmtTime(d, "yyyy-MM-dd")
                    }
                }

                Text {
                    height: imgUser.visible? parent.height: undefined
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: AppStyle.font_smal
                    font.family: AppStyle.fontNameMain
                    text: qsTr("%1 viewed").arg(infoJs.viewCountShow?infoJs.viewCountShow:infoJs.visit.views)
                }

                Text {
                    height: imgUser.visible? parent.height: undefined
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: AppStyle.font_smal
                    font.family: AppStyle.fontNameMain
                    text: infoJs.channelName?infoJs.channelName:""
                }
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            Global.openArticle(infoJs.href?infoJs.href:infoJs.resourceId)
        }
    }
}
