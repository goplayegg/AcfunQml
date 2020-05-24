import QtQuick 2.1
import QmlVlc 0.1

import "qrc:///ui/danmaku/"
import "qrc:///ui/global/"

Rectangle {
    color: "black"//"transparent"//

    signal videoReady
    property string videoUrl: ""//file:///D:/1.mp4
    property string title :"Title"
    function stop(){
        vlcPlayer.stop()
        danmaku.close()
        console.log("vlcPlayer stop")
    }

    function start(js){
        stop()
        AcService.getVideo(js.vId,js.sId,js.sType,funPlayVideo)
        danmaku.open(js)
    }

    function funPlayVideo(js){
        if(0 !== js.result){
            //弹错误
            //js.error_msg
        }

        var playInfos = js.playInfo.streams
        var url = playInfos[1].playUrls[0]
        console.log("url"+url)
        videoUrl = url
    }

    function togglePause(){
        vlcPlayer.togglePause()
    }

    VlcPlayer {
        id: vlcPlayer
        mrl: videoUrl
        speed: controlLayer.playSpeed
        volume: controlLayer.playVolume*100
        onStateChanged: {
            if(VlcPlayer.Playing == state ||
                VlcPlayer.Error  == state){
                videoReady()
            }
            danmaku.paused = (vlcPlayer.state === VlcPlayer.Paused)

        }
    }

    VlcVideoSurface {
        id: videoSur
        source: vlcPlayer
        anchors.fill:parent
        anchors.margins: 5
    }

    DanmakuLayer {
        id: danmaku
        anchors.fill: parent
        clip: true
    }

    ControlLayer {
        id: controlLayer

        z: 5
        anchors.fill: parent
        titleName:title
        progressSlidePos:vlcPlayer.position;
        onPlayBtnChanged: {
            vlcPlayer.togglePause();
        }
        onPlayPosChanged:{
            vlcPlayer.position = pos
        }
    }
    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
        onClicked: togglePause()
    }
}
