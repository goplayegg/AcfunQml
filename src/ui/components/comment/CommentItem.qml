import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"

Row {
    id: control
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: 20
    leftPadding: 10
    property var js

    signal replyTo(var cmtId)

    AvatarWithCover {
        id: avatarItem
        width: 90
        height: width
        avatarUrl: js.headImgUrl
        coverUrl: js.avatarImage
    }

    Column {
        id: col
        spacing: 8
        width: parent.width-avatarItem.width-control.spacing
        Row {
            spacing: 8
            Text {
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameMain
                font.weight: Font.Normal
                text: js.userName
            }
            Text {
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameMain
                font.weight: Font.Normal
                color: AppStyle.thirdForeColor
                text: qsTr("post time")+" " +js.postDate
            }
            Text {
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameMain
                font.weight: Font.Normal
                color: AppStyle.thirdForeColor
                text: "#" +js.floor
            }
        }
        CommentContent {
            id: cmtArea
            anchors.left: parent.left
            anchors.right: parent.right
            contentText: js.content
        }
        Row {
            spacing: 18
            RoundBtnWithText {
                id: btnLike
                icon: "qrc:/assets/img/common/like0.png"
                iconChecked: "qrc:/assets/img/common/like1.png"
            }
            RoundBtnWithText {
                id: btnReply
                text: ""//qsTr("Reply")
                icon: "qrc:/assets/img/common/cmt0.png"
                iconChecked: "qrc:/assets/img/common/cmt1.png"
                onClicked: {
                    console.log("reply to:"+js.commentId)
                    replyTo(js.commentId)
                }
            }
            Text {
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameMain
                font.weight: Font.Normal
                color: AppStyle.thirdForeColor
                height: btnLike.height
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Send by") + js.deviceModel
            }
        }
        Loader {
            id: subCmt
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }

    Component.onCompleted: {
        if("" !== js.subCommentsJson){
            subCmt.source = "SubCommentList.qml"
            subCmt.item.open(js.subCommentsJson, js.commentId)
        }
        var likeTxt = ""//qsTr("Like")
        if(js.likeCount)
            likeTxt+=js.likeCountFormat
        btnLike.text = likeTxt
        btnLike.customChecked = js.isLiked
    }
}
