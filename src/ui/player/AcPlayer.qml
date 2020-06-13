import QtQuick 2.1
import QmlVlc 0.1

import "qrc:///ui/danmaku/"
import "qrc:///ui/global/"
import "qrc:///ui/components/"
import "qrc:///ui/player/ctrl"
import "qrc:///ui/global/libraries/functions.js" as FUN

FullScreen {
    id: rootFull
    fullApp:  ctrlFrame.fullApp
    fullScreen: ctrlFrame.fullScreen
    smallWindow: ctrlFrame.smallWindow
    signal videoReady
    property var vidioInfo
    function stop(){
        vlcPlayer.stop()
        danmaku.close(true)
    }

    function start(js){
        vidioInfo = js
        stop()
        AcService.getVideo(js.vId,js.sId,js.sType,funPlayVideo)
        danmaku.open(js.vId, 0)
    }

    function funPlayVideo(js){
        if(0 !== js.result){
            //弹错误
            //js.error_msg
        }

        var playInfos = js.playInfo.streams
        var url = playInfos[1].playUrls[0]
        console.log("current playing url:"+url)
        vlcPlayer.mrl = url//"file:///D:/1.mp4"//
        ctrlFrame.duration = FUN.formatTime(parseInt(js.playInfo.duration/1000))
    }

    function togglePause(){
        vlcPlayer.togglePause()
    }
    DanmControl {
        id: danmCtrl
        anchors.bottom: parent.bottom
        width: parent.width
        onDanmakuClosedChanged: {
            if(danmakuClosed)
                danmaku.close(false)
            else{
                danmaku.open(vidioInfo.vId, vlcPlayer.time)
            }
        }
    }

    Rectangle {
        anchors.top: parent.top
        anchors.bottom: danmCtrl.top
        width: parent.width
        color: "black"

        VlcPlayer {
            id: vlcPlayer
            speed: ctrlFrame.speed
            volume: ctrlFrame.volume
            onStateChanged: {
                if(VlcPlayer.Playing === state ||
                    VlcPlayer.Error  === state){
                    videoReady()
                }
                if(VlcPlayer.Paused === state){
                    ctrlFrame.paused = true
                }else if(VlcPlayer.Playing === state ||
                         VlcPlayer.Buffering === state){
                    ctrlFrame.paused = false
                }
                console.log("vlcPlayer status:"+ state)
            }
        }

        VlcVideoSurface {
            id: videoSur
            source: vlcPlayer
            anchors.fill:parent
            anchors.margins: 5

            MouseArea {
                function showCtrl(){
                    ctrlFrame.visible = true
                    tmCtrlHide.restart()
                }

                anchors.fill: parent
                hoverEnabled: true
                onMouseXChanged: showCtrl()
                onMouseYChanged: showCtrl()
                onEntered: showCtrl()
                onExited: {
                    tmCtrlHide.start()
                }

                onClicked: {
                    console.log("clicked player")
                    togglePause()
                }
                onDoubleClicked: {
                    ctrlFrame.fullScreen = !ctrlFrame.fullScreen
                }
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
                    danmaku.open(vidioInfo.vId, vlcPlayer.time)
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
}
