import QtQuick 2.1
import QmlVlc 0.1

import "qrc:///ui/danmaku/"
import "qrc:///ui/global/"
import "qrc:///ui/player/ctrl"
import "qrc:///ui/libraries/functions.js" as FUN

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
        console.log("current playing url:"+url)
        videoUrl = url
        ctrlFrame.duration = FUN.formatTime(parseInt(js.playInfo.duration/1000))
    }

    function togglePause(){
        vlcPlayer.togglePause()
    }

    VlcPlayer {
        id: vlcPlayer
        mrl: videoUrl
        speed: ctrlFrame.speed
        volume: ctrlFrame.volume
        onStateChanged: {
            if(VlcPlayer.Playing == state ||
                VlcPlayer.Error  == state){
                videoReady()
            }
            ctrlFrame.paused = (vlcPlayer.state === VlcPlayer.Paused)
        }
    }

    VlcVideoSurface {
        id: videoSur
        source: vlcPlayer
        anchors.fill:parent
        anchors.margins: 5

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                tmCtrlHide.stop()
                ctrlFrame.visible = true
            }
            onExited: {
                tmCtrlHide.start()
            }
            onClicked: togglePause()
        }
        VideoControl {
            id: ctrlFrame
            anchors.bottom: parent.bottom
            width: parent.width
            visible: false
            position: vlcPlayer.position
            timeCurrent: FUN.formatTime(parseInt(vlcPlayer.time/1000))
            onPausedChanged: {
                if(paused)
                    vlcPlayer.pause()
                else
                    vlcPlayer.play()
            }
            onMuteChanged: {
                mute?vlcPlayer.mute():vlcPlayer.unMute();
            }
            onChangePosition: {
                vlcPlayer.position = pos
            }
        }
        Timer {
            id: tmCtrlHide
            interval: 3000
            onTriggered: {
                ctrlFrame.visible = false
            }
        }
    }

    DanmakuLayer {
        id: danmaku
        anchors.fill: parent
        clip: true
        speed: ctrlFrame.speed
        paused: ctrlFrame.paused
    }
}
