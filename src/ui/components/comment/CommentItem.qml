import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

Row {
    id: control
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: 20
    leftPadding: 10
    property var js

    Item {
        id: itemAvatar
        width: 90
        height: width

        Image {
            id: imgAvatar
            width: 80
            height: width
            anchors.centerIn: parent
            sourceSize.width: width
            sourceSize.height: height
            source: js.headImgUrl
        }

        Loader {
            id: imgAvatarBk
            anchors.fill: parent
            visible: false
        }
    }

    Component {
        id: cmpGif
        AnimatedImage {
            id: gif
        }
    }

    Component {
        id: cmpImg
        Image {
            id: img
        }
    }

    Column {
        id: col
        width: parent.width-imgAvatar.width-control.spacing
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
        if(undefined !== js.avatarImage){//头饰挂件
            var gifIdx = js.avatarImage.indexOf(".gif")
            if(gifIdx !== -1){
                imgAvatarBk.sourceComponent = cmpGif
                imgAvatarBk.item.source = js.avatarImage.substring(0, gifIdx+4)
            }else{
                imgAvatarBk.sourceComponent = cmpImg
                imgAvatarBk.item.source = js.avatarImage
            }
            imgAvatarBk.visible = true
        }

        if("" !== js.subCommentsJson){
            subCmt.source = "SubCommentList.qml"
            subCmt.item.open(js.subCommentsJson, js.commentId)
        }
    }
}
