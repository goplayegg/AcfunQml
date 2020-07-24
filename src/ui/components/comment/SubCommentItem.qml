import QtQuick 2.12
import QtQuick.Controls 2.12
//import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"

Row {
    id: control
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: 20
    height: 100
    leftPadding: 10
    property var js

    RoundImage {
        id: imgAvatar
        width: 80
        height: width
        source: js.headImgUrl
        onClicked: {
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
    }
}
