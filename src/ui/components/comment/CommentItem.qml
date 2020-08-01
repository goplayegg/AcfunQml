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

    AvatarWithCover {
        id: avatarItem
        width: 90
        height: width
        avatarUrl: js.headImgUrl
        coverUrl: js.avatarImage
    }

    Column {
        id: col
        width: parent.width-avatarItem.width-control.spacing
        Row {
            Text {
                text: js.userName
            }
            Text {
                text: js.postDate
            }
            Text {
                text: js.floor
            }
        }
        CommentContent {
            id: cmtArea
            anchors.left: parent.left
            anchors.right: parent.right
            contentText: js.content
        }
        Row {
            Text {
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
    }
}
