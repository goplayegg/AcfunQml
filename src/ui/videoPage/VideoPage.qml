import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/player/"
import "qrc:///ui/global/"
import "qrc:///ui/components/comment/"
import "qrc:///ui/global/libraries/functions.js" as FUN

Item{
    id: root

    function open(js){
        if(undefined === js.vid){
            AcService.getVideoByAc(js.contentId, function(res){
                    res.contentId = res.dougaId
                    res.contentType = 2
                    res.vid = res.videoList[0].id
                    openPrivate(res)
                })
        }else{
            openPrivate(js)
        }
    }

    function back(){
        stop()
    }

    function openPrivate(js){
        player.start(js)
        detail.open(js)
        comment.open(js)
    }

    function stop() {
        player.stop()
    }

    ScrollView {
        id: scroll
        anchors.fill: parent
        clip: true
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        Column {
            width: root.width-30
            Item {
                id: playerParent
                anchors.left: parent.left
                anchors.right: parent.right
                height: root.height-140//露出up头像
                AcPlayer {
                    id: player
                    anchors.fill: parent
                    normalParent: playerParent
                    onVideoReady: {
                        busyBox.running = false
                    }
                    onVideoEnded: {
                        detail.nextPart()
                    }
                }
            }

            VideoDetail {
                id: detail
                anchors.left: parent.left
                anchors.right: parent.right
                onChangeVideoPart: {
                    busyBox.running = true
                    player.changePart(vInfo)
                }
            }

            CommentList {
                id: comment
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }
    }
    Component.onCompleted: {
        console.log("VideoPage completed")
        var d=new Date();
        console.log(FUN.fmtTime(d, "hh:mm:ss"))
    }
}
