import QtQuick 2.0
import QtQuick.Controls 2.12

import "qrc:///ui/global/styles/"

Item {
    property alias avatarUrl: imgAvatar.source
    property var coverUrl: undefined
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
