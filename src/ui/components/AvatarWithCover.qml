import QtQuick 2.0
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"

//         头像+挂件
//           168
//---------------------------
//          Cover           |
//                          |
//           110            |       147
//  --------------------    |  142
//  |                  |    |
//  |       Avatar     | 110|
//  |                  |    |
//  |                  |    |
//---------------------------
//                          | 5
//---------------------------

Item {
    property alias size: itemAvatar.width
    property alias avatarUrl: imgAvatar.source
    property var coverUrl: undefined
    id: itemAvatar
    width: 90
    height: width*147/168

    RoundImage {
        id: imgAvatar
        size: itemAvatar.width*110/168
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: itemAvatar.width*5/168
    }

    Loader {
        id: imgAvatarCover//头饰挂件
        anchors.fill: parent
        visible: false
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

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Global.openUser(userId)
        }
    }

    Component.onCompleted: {
        loadAvatarCover()
    }

    function loadAvatarCover(){
        if(undefined === coverUrl){
            return
        }
        var gifIdx = coverUrl.indexOf(".gif")
        if(gifIdx !== -1){
            imgAvatarCover.sourceComponent = cmpGif
            imgAvatarCover.item.source = coverUrl.substring(0, gifIdx+4)
        }else{
            imgAvatarCover.sourceComponent = cmpImg
            imgAvatarCover.item.source = coverUrl
        }
        imgAvatarCover.visible = true
    }
}
