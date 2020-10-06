import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"

Rectangle {
    id:root
    height: 90
    color: AppStyle.secondBkgroundColor

    property var infoJs: ({})

    AutoImage {
        id:imgCover
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 4
        width: height*125/70
        source: infoJs.coverUrl
    }

    Item {
        anchors.left: imgCover.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 4
        Text {
            anchors.left: parent.left
            anchors.right: parent.right
            font.pointSize: AppStyle.font_normal
            font.bold: true
            wrapMode: Text.WordWrap
            text: infoJs.title
        }
        Row{
            anchors.bottom: rowTime.top
            anchors.bottomMargin: 4
            spacing: 4
            Image {
                height: textPlayCnt.height
                width: height
                sourceSize: Qt.size(width, height)
                source: "qrc:/assets/img/play.png"
            }
            Text {
                id:textPlayCnt
                text: infoJs.viewCountShow
            }
            Image {
                height: textPlayCnt.height
                width: height
                sourceSize: Qt.size(width, height)
                source: "qrc:/assets/img/coment.png"
            }
            Text {
                text: infoJs.commentCountShow
            }
            Image {
                height: textPlayCnt.height
                width: height
                sourceSize: Qt.size(width, height)
                source: "qrc:/assets/img/banana.png"
                visible: infoJs.bananaCountShow !== undefined
            }
            Text {
                text: (infoJs.bananaCountShow !== undefined)?infoJs.bananaCountShow:""
            }
        }
        Row{
            id: rowTime
            anchors.bottom: parent.bottom
            spacing: 4
            Text {
                text: infoJs.createTime
            }
            Text {
                text: infoJs.channel.name
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            infoJs.vid = infoJs.videoList[0].id
            infoJs.contentId = infoJs.dougaId
            infoJs.contentType = 2
            Global.openVideo(infoJs)
        }
    }
}
