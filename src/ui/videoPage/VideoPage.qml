import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/player/"
import "qrc:///ui/global/"
import "qrc:///ui/global/libraries/functions.js" as FUN

Item{
    id: root

    function open(js){
        player.start(js)
        detail.open(js)
        //AcService.getComment(js.vId, showComment)
    }

    function back(){
        stop()
    }

    function showComment(res){
        console.log("showComment"+JSON.stringify(res))
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
                }
            }

            VideoDetail {
                id: detail
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
