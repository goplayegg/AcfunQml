import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/player/"
import "qrc:///ui/global/"
import "qrc:///ui/global/libraries/functions.js" as FUN

Item{
    id:root

    property alias title :player.title

    function open(js){
        title = js.title
        player.start(js)
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

    AcPlayer {
        id: player
        anchors.fill: parent
        normalParent: root
        onVideoReady: {
            busyBox.running = false
        }
    }

    Component.onCompleted: {
        console.log("VideoPage completed")
        var d=new Date();
        console.log(FUN.fmtTime(d, "hh:mm:ss"))
    }
}
