import QtQuick 2.1
import QmlVlc 0.1

import "qrc:///ui/global/"
import "qrc:///ui/components/"
import "qrc:///ui/player/ctrl"
import "qrc:///ui/global/libraries/functions.js" as FUN

Item {
    id: rootFull
    property int playStat: 0//0-初始 1-播放中 2-暂停 3-播放结束 4-错误
    property var videoInfo
    property var playInfo
    function stop(){
        vlcPlayer.stop()
        playStat = 0
    }

    Component.onCompleted: start()

    function start(){
        stop()
        AcService.getVideo(videoInfo.vid,videoInfo.contentId,videoInfo.contentType,funPlayVideo)
    }

    function funPlayVideo(js){
        if(0 !== js.result){
            playStat = 4
            PopMsg.showError(js, mainwindowRoot)
            return
        }
        playInfo = js.playInfo
        vlcPlayer.mrl = playInfo.streams[playInfo.streams.length-1].playUrls[0]
    }

    function togglePause(){
        vlcPlayer.togglePause()
    }

    Rectangle {
        anchors.fill: parent
        color: "black"

        VlcPlayer {
            id: vlcPlayer
            onStateChanged: {
                if(VlcPlayer.Error  === state){
                    playStat = 4
                }
                else if(VlcPlayer.Paused === state){
                    playStat = 2
                }else if(VlcPlayer.Playing === state ||
                         VlcPlayer.Buffering === state){
                    playStat = 1
                }else if(VlcPlayer.Ended === state){
                    playStat = 3
                }
                console.log("vlcPlayer status:"+ state)
            }
        }

        VlcVideoSurface {
            id: videoSur
            source: vlcPlayer
            anchors.fill:parent

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    console.log("clicked player")
                    togglePause()
                }
            }
        }
    }

    Connections {
        target: Global
        function onOpenCircleDetail(info) {
            stop()
        }
        function onOpenVideo(js) {
            stop()
        }
    }
}
