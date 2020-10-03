import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"
import "qrc:///ui/player/"

Item {
    id:root
    width: 190
    height: 110*width/190

    property var infoJs: ({})
    signal openVideoDetail(var js)

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
                btnPlay.visible = (player.item.playStat === 0)
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
            checkable: true
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
            checkable: true
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
            checkable: true
            icon.name: AppIcons.mdi_pocket
            size: 40
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 60
        }
    }

    function makeJson(){
        infoJs.contentId = infoJs.dougaId
        infoJs.contentType = 2
        infoJs.vid = infoJs.videoList[0].id
    }

    function detail(){
        if(player.playState !== 0){
            player.item.stop()
            player.visible = false
        }
        makeJson()
        openVideoDetail(infoJs)
    }

    function play(){
        makeJson()
        player.visible = true
        player.setSource("qrc:///ui/player/SimplePlayer.qml",
                          {"videoInfo": infoJs})
    }
}
