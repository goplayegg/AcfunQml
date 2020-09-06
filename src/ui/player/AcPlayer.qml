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
    property var videoInfo
    function stop(){
        vlcPlayer.stop()
        danmaku.close(true)
    }

    function start(js){
        videoInfo = js
        stop()
        AcService.getVideo(js.vid,js.contentId,js.contentType,funPlayVideo)
        danmaku.open(js.vid, 0)
    }

    function changePart(js){//分p
        videoInfo.vid = js.id
        stop()
        AcService.getVideo(js.id,videoInfo.contentId,videoInfo.contentType,funPlayVideo)
        danmaku.open(js.id, 0)
    }

    function funPlayVideo(js){
        if(0 !== js.result){
            videoReady()
            busyBox.running = false
            PopMsg.showError(js, mainwindowRoot)
            return
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
        property var componentBanana: null
        id: danmCtrl
        visible: (fullScreen||fullApp||smallWindow)?ctrlFrame.visible:true
        anchors.bottom: parent.bottom
        width: parent.width
        onDanmakuClosedChanged: {
            if(danmakuClosed)
                danmaku.close(false)
            else{
                danmaku.open(videoInfo.vid, vlcPlayer.time)
            }
        }
        onClickBanana: {
            if(null == componentBanana){
                componentBanana = Qt.createComponent("qrc:/ui/components/Banana.qml")
            }
            if(componentBanana.status === Component.Ready){
                console.log("throw Banana")
                var tmp = componentBanana.createObject(rootFull,{"fromPos":"615,540", "toPos":"1,1"})
                tmp.start();
            }
        }
        onSendDanm: {
            danmaku.addSelfDanm(danmJson)
            danmJson.body = encodeURIComponent(danmJson.body)
            danmJson.position = vlcPlayer.time
            danmJson.videoId = videoInfo.vid
            danmJson.id = videoInfo.contentType
            AcService.sendDanm(danmJson, function(res){
                if(0!==res.result){
                    console.log("danmaku send failed:"+JSON.stringify(danmJson))
                    return
                }
                danmCtrl.clearInput()
            })
        }
    }

    Rectangle {
        anchors.top: parent.top
        anchors.bottom: danmCtrl.visible?danmCtrl.top:parent.bottom
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
                    danmaku.open(videoInfo.vid, vlcPlayer.time)
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
            danmOpacity: danmCtrl.danmOpacity
        }
    }
}
