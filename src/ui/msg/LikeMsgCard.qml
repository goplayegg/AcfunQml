import QtQuick 2.0
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"
import "qrc:///ui/components/comment"
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"
import "qrc:///ui/global/libraries/functions.js" as FUN

Rectangle {
    property var msgInfo
    property real cardMargin: 5
    id: control
    width: 500
    implicitHeight: col.implicitHeight+2*cardMargin
    color: AppStyle.secondBkgroundColor

    RoundBtnWithText {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 5
        enabled: false
        text: "+1"
        icon: "qrc:/assets/img/common/like0.png"
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("resource:"+msgInfo.resourceId+" type:"+msgInfo.resourceType)
            switch(msgInfo.resourceType){
            case 3:
                Global.openArticle(msgInfo.resourceId)
                break;
            case 2:
                Global.openVideo({contentId: msgInfo.resourceId})
                break;
            case 10:
                Global.openCircleDetail(msgInfo.resourceId, true)
                break;
            }
        }
    }
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
                    text: {
                        var a=new Date();
                        a.setTime(msgInfo.timestamp)
                        return FUN.fmtTime(a, "yyyy-MM-dd hh:mm:ss")
                    }
                    leftPadding: 3
                    font.pixelSize: AppStyle.font_smal
                    font.family: AppStyle.fontNameMain
                }
            }
        }

        Loader {
            id: ldTitle
            active: msgInfo.notifyType === 14//投稿点赞
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 4
            sourceComponent:  Label {
                color: "#0000ff"
                wrapMode: TextArea.Wrap
                font.pixelSize: AppStyle.font_xlarge
                font.family: AppStyle.fontNameMain
                font.weight: Font.Medium
                text: msgInfo.extData.resourceTitle
            }
        }

        Loader {
            active: !ldTitle.active
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 4
            sourceComponent:  CommentText {
                contentText: msgInfo.extData.commentContent?msgInfo.extData.commentContent
                                                           :msgInfo.extData.text?msgInfo.extData.text
                                                                                :msgInfo.extData.resourceTitle
            }
        }

    }
}
