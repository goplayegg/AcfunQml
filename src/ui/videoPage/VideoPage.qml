import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/global/"

Item{
    id:root

    property alias videoUrl :player.videoUrl
    property alias title :player.title

    function open(js){
        title = js.title
        AcService.getVideo(js.vId,js.sId,js.sType,funPlayVideo)
        player.setDanm(js)
    }

    function funPlayVideo(js){
        if(0 !== js.result){
            //弹错误
            //js.error_msg
        }

        var playInfos = js.playInfo.streams
        var url = playInfos[1].playUrls[0]
        console.log("url"+url)
        stop()
        videoUrl = url
    }

    function stop(){
        player.stop()
    }

    VideoLayer{
        id: player
        anchors.fill: parent
    }

    Component.onCompleted: {
        console.log("VideoPage completed")
    }
}
