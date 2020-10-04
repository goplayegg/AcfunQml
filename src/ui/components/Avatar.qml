import QtQuick 2.0
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"

Item {
    property alias size: imgAvatar.width
    property var avatarUrl: undefined
    property var userId: undefined
    implicitWidth: imgAvatar.width
    implicitHeight: imgAvatar.height

    Loader {
        id: imgAvatar
        width: 32
        height: width
    }

    Component {
        id: cmpGif
        AnimatedImage {
            id: gif
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    openUserPage()
                }
            }
        }
    }

    Component {
        id: cmpImg
        RoundImage {
            size: imgAvatar.width
            onClicked: {
                openUserPage()
            }
        }
    }

    Component.onCompleted: loadAvatarCover()
    onAvatarUrlChanged: {
        if(imgAvatar.item)
            loadAvatarCover()
    }

    function loadAvatarCover(){
        var gifIdx = avatarUrl.indexOf(".gif")
        if(gifIdx !== -1){
            imgAvatar.sourceComponent = cmpGif
            imgAvatar.item.source = avatarUrl.substring(0, gifIdx+4)
        }else{
            imgAvatar.sourceComponent = cmpImg
            imgAvatar.item.source = avatarUrl
        }
    }

    function openUserPage(){
        console.log("user avatar click:"+userId)
        //var url = "https://www.acfun.cn/u/"+userJson.userId
        //Qt.openUrlExternally(url)
        //AcService.getUserInfoId(userJson.userId, function(res){
        //    })
        //AcService.isFollowingUid(userJson.userId, function(res){
        //    })
        AcService.getUserProfile(userId, 0, function(res){
            })
        //AcService.getUserResource(userJson.userId, 2, 0, function(res){
        //    })
        //AcService.getUserResource(userJson.userId, 3, 0, function(res){
        //    })
    }
}
