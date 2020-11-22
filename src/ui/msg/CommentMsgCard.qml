import QtQuick 2.0
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"
import "qrc:///ui/components/comment"
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"

Rectangle {
    property var msgInfo
    property real cardMargin: 5
    id: control
    width: 300
    implicitHeight: col.implicitHeight+2*cardMargin
    color: AppStyle.secondBkgroundColor

    signal reply(var msgInfo)
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

        CommentText {
            id: cmtArea
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 4
            contentText: msgInfo.commentContent
        }

        Rectangle {
            id: rectRepliedBk
            anchors.left: parent.left
            anchors.right: parent.right
            height: cmtReplied.height
            color: "transparent"
            border.color: AppStyle.thirdBkgroundColor
            border.width: 1
            CommentText {
                id: cmtReplied
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 4
                textColor: AppStyle.thirdForeColor
                contentText: msgInfo.replyCommentContent?msgInfo.replyCommentContent:msgInfo.resourceTitle
            }
        }

        Row {
            id: rowBtns
            spacing: 8
            anchors.left: parent.left
            anchors.right: parent.right
            RoundBtnWithText {//回复
                id: btnReply
                icon: "qrc:/assets/img/common/cmt0.png"
                iconChecked: "qrc:/assets/img/common/cmt1.png"
                onClicked: {
                    console.log("reply to commentId:"+msgInfo.commentId)
                    reply(msgInfo)
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
            IconBtn {
                id: btnDetail
                height: 40
                width: 40
                iconFontSize: 30
                noBorder: true
                text: msgInfo.resourceType === 3?AppIcons.mdi_book_open_outline:AppIcons.mdi_play_circle_outline
                color: hovered?AppStyle.primaryColor:AppStyle.foregroundColor
                tip: msgInfo.resourceType === 3?qsTr("Open article"):qsTr("Open video")
                onClicked: {
                    console.log("resource:"+msgInfo.resourceId+" type:"+msgInfo.resourceType)
                    switch(msgInfo.resourceType){
                    case 3:
                        Global.openArticle(msgInfo.resourceId)
                        break;
                    case 2:
                        Global.openVideo({contentId: msgInfo.resourceId})
                        break;
                    }
                }
            }
        }
    }

}
