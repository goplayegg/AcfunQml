﻿import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"
import "qrc:///ui/player/"

Item {
    id:root
    width: 190
    height: 110*width/190

    property var infoJs: ({})

    AutoImage {
        id: imgCover
        height: 110*width/190
        width: parent.width
        source: infoJs.coverUrl
    }

    Loader {
        id: player
        property int playState: 0
        anchors.fill: parent
        Connections {
            target: player.item
            function onPlayStatChanged() {
                player.playState = player.item.playStat
                //btnPlay.visible = (player.item.playStat === 0)
            }
        }
        onPlayStateChanged: {
            if(0 === playState){
                visible = false
                btnPlay.visible = true
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            detail()
        }
        onEntered: {
            btnPlay.anchors.horizontalCenterOffset = -60
            btnPocket.visible = true
            btnDetail.visible = true
            if(0 !== player.playState){
                btnPlay.visible = true
            }
        }
        onExited: {
            btnPlay.anchors.horizontalCenterOffset = 0
            btnPocket.visible = false
            btnDetail.visible = false
            if(0 !== player.playState){
                btnPlay.visible = false
            }
        }

        RoundButton {
            id: btnPlay
            icon.name: player.playState === 1 ? AppIcons.mdi_pause : AppIcons.mdi_play
            size: 40
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                if(player.playState === 1 || player.playState === 2)
                    player.item.togglePause()
                else
                    play()
            }
        }

        RoundButton {
            id: btnDetail
            visible: false
            icon.name: AppIcons.mdi_monitor
            size: 40
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                detail()
            }
        }

        RoundButton {
            id: btnPocket
            visible: false
            property bool pocketed: false
            textColor: pocketed?AppStyle.primaryColor:AppStyle.foregroundColor
            icon.name: AppIcons.mdi_pocket
            size: 40
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 60
            onClicked: {
                if(!pocketed){
                    AcService.addWaiting(infoJs.dougaId, 2, function(res){
                        if(res.result === 0)
                            pocketed = true
                    });
                }else{
                    AcService.cancelWaiting(infoJs.dougaId, 2, function(res){
                        if(res.result === 0)
                            pocketed = false
                    });
                }
            }
        }
    }

    function makeJson(){
        infoJs.contentId = infoJs.dougaId
        infoJs.contentType = 2
        if(undefined !== infoJs.videoList)
            infoJs.vid = infoJs.videoList[0].id
    }

    function detail(){
        makeJson()
        if(undefined === infoJs.title)
            infoJs.vid = undefined
        Global.openVideo(infoJs)
    }

    function play(){
        makeJson()
        player.visible = true
        //TODO 改为播放器数量固定上限，每次复用，避免重复销毁
        player.setSource("qrc:///ui/player/SimplePlayer.qml",
                          {"videoInfo": infoJs})
    }

    function stop(){
        if(player.playState !== 0){
            player.item.stop()
        }
    }
}
