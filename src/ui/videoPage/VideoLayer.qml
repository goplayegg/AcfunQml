import QtQuick 2.1
import QtQuick.Layouts 1.0
import QmlVlc 0.1

import "qrc:///ui/player/"
import "qrc:///ui/danmaku/"

Rectangle {
    color: "transparent"

    property string videoUrl: ""//file:///D:/1.mp4
    property string title :"Title"
    function stop(){
        vlcPlayer.stop()
        console.log("vlcPlayer stop")
    }

    function start(){

    }

    function setDanm(js){
        danmaku.open(js)
    }

    VlcPlayer {
        id: vlcPlayer;
        mrl: videoUrl;
        speed: controlLayer.playSpeed
        volume: controlLayer.playVolume*100
        //播放状态
    }
    VlcVideoSurface {
        source: vlcPlayer;
        anchors.fill:parent
        anchors.margins: 5
    }

    DanmakuLayer{
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
        onClicked: vlcPlayer.togglePause()

    }
}
