import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/player/"
import "qrc:///ui/global/"
import "qrc:///ui/global/libraries/functions.js" as FUN

Item{
    id:root

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

    Item {
        id: playerParent
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: detail.top
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
        anchors.bottom: parent.bottom
    }

    Component.onCompleted: {
        console.log("VideoPage completed")
        var d=new Date();
        console.log(FUN.fmtTime(d, "hh:mm:ss"))
    }
}
