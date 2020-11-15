import QtQuick 2.0
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"

Rectangle {
    property var msgInfo
    property real cardMargin: 5
    id: control
    width: 300
    implicitHeight: col.implicitHeight+2*cardMargin
    color: AppStyle.secondBkgroundColor

    Column {
        id: col
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: cardMargin
        anchors.topMargin: cardMargin+4
        Item {//用户
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 4
            height: 38

            Avatar {
                id: imgAvatar
                size: 32
                avatarUrl: msgInfo.userImg
                userId: msgInfo.userId
            }

            Column {
                spacing: 2
                anchors.verticalCenter: imgAvatar.verticalCenter
                anchors.left: imgAvatar.right
                anchors.leftMargin: 10
                TextArea {
                    text: msgInfo.userName
                    padding: 0
                    selectByMouse: true
                    readOnly: true
                    font.weight: Font.Bold
                    font.pixelSize: AppStyle.font_large
                    font.family: AppStyle.fontNameMain
                }
                Label {
                    text: msgInfo.time
                    leftPadding: 3
                    font.pixelSize: AppStyle.font_smal
                    font.family: AppStyle.fontNameMain
                }
            }
        }

        TextArea {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 4
            selectByMouse: true
            readOnly: true
            wrapMode: Text.WordWrap
            font.weight: Font.Bold
            font.pixelSize: AppStyle.font_normal
            font.family: AppStyle.fontNameMain
            textFormat: TextEdit.AutoText
            text: msgInfo.commentContent
            onLinkActivated: {
                console.log("open circle link:"+link)
            }
            onPressed: {
                openDetail()
            }
        }

        Row {
            id: rowBtns
            spacing: 8
            anchors.left: parent.left
            anchors.right: parent.right
            RoundBtnWithText {//评论
                id: btnComment
                //text: msgInfo.commentCount
                icon: "qrc:/assets/img/common/cmt0.png"
                iconChecked: "qrc:/assets/img/common/cmt1.png"
                onClicked: {
                    openDetail()
                }
            }
            RoundBtnWithText {
                id: btnLike
                //text: msgInfo.likeCount
                //customChecked: msgInfo.isLike
                enabled: !customChecked
                icon: "qrc:/assets/img/common/like0.png"
                iconChecked: "qrc:/assets/img/common/like1.png"
            }
        }
    }

    Component.onCompleted: {
    }

}
