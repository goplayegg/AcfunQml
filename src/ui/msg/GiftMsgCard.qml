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
    width: 500
    implicitHeight: col.implicitHeight+2*cardMargin
    color: AppStyle.secondBkgroundColor

    RoundBtnWithText {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 5
        enabled: false
        text: "+" + (msgInfo.bananaCount?msgInfo.bananaCount:msgInfo.giftCount)
        icon: msgInfo.bananaCount?"qrc:/assets/img/common/goldBanana.png"
                                 :msgInfo.giftId === "桃子" ? "qrc:/assets/img/common/peach.png"
                                                           : "qrc:/assets/img/common/gift.png"
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
                    text: msgInfo.time
                    leftPadding: 3
                    font.pixelSize: AppStyle.font_smal
                    font.family: AppStyle.fontNameMain
                }
            }
        }
        Label {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 4
            color: msgInfo.resourceTitle?"#0000ff":AppStyle.foregroundColor
            wrapMode: TextArea.Wrap
            font.pixelSize: AppStyle.font_xlarge
            font.family: AppStyle.fontNameMain
            font.weight: Font.Medium
            text: msgInfo.resourceTitle?msgInfo.resourceTitle
                                       :msgInfo.notifyContent?msgInfo.notifyContent
                                                             :"动态"
        }
    }
}
