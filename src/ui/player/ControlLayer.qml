import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import "qrc:///ui/global/styles/"
import "qrc:///ui/components/" as COM
import "qrc:///ui/player/" as PLAYER
import "qrc:///ui/libraries/functions.js" as FUN

Item {
    id: control

    property int bottomMargin: 16
    property alias playVolume: volumeCtrl.playVolume
    property var playSpeed: 1.0
    property var progressSlidePos: 0.0
    property alias titleName: mediaTitle.text
    property var danmakuOpenStat: false

    signal playBtnChanged(var play);
    signal playPosChanged(var pos);

    Label {
        id: mediaTitle

        anchors.left: playbackProgress.left
        anchors.bottom: playbackProgress.top
        font.pixelSize: 12
        width: playbackProgress.width
        elide: Text.ElideRight
    }

    RowLayout {
        id: tickTime

        width: playbackProgress.width
        anchors.left: playbackProgress.left
        anchors.top: playbackProgress.bottom
        Label {
            id: timeLable
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            //text: mediaPlayer.time.toString()
            font.pixelSize: 10
        }

        Item { Layout.fillWidth: true }

        Label {
            id: durationLable
            Layout.alignment: Qt.AlignRight |  Qt.AlignTop
            //text: mediaPlayer.duration.toString()
            font.pixelSize: 10
        }
    }

    PLAYER.ProgressControl {
        id: playbackProgress
        slidePos:progressSlidePos;
        anchors.bottom: parent.bottom
        anchors.bottomMargin: control.bottomMargin + 12

        onPressedChanged: {
            playPosChanged(value)
        }
    }

    PLAYER.PlayControl {
        id: playButton

        anchors.bottom: parent.bottom
        anchors.bottomMargin: control.bottomMargin
        x: parent.width - 140
        onPlayChanged: {
            playBtnChanged(play);
        }
    }
    COM.RoundButton {
        id: previousButton

        anchors.right: playButton.left
        y: playButton.y + playButton.height / 2 - previousButton.height / 2
        icon.name: AppIcons.mdi_skip_previous
        size: AppStyle.sm
        textColor: "white"
        onClicked: {
            speedMenu.popup()
        }
    }
    COM.RoundButton {
        id: nextButton

        anchors.left: playButton.right
        y: playButton.y + playButton.height / 2 - nextButton.height / 2
        icon.name: AppIcons.mdi_skip_next
        size: AppStyle.sm
        textColor: "white"
        onClicked: {
            danmakuOpenStat = !danmakuOpenStat
        }
    }
    PLAYER.VolumeControl {
        id: volumeCtrl
        anchors.left: nextButton.right
        y: nextButton.y + nextButton.height / 2 - nextButton.height / 2
    }

    function changeSpeed(speed, obj){
        playSpeed = speed
        obj.checked = true
    }


    ButtonGroup {
        id: btnGroup
        //buttons: speedMenu.children
    }
    Menu { // 速度菜单
            title: "Speed"
            id: speedMenu

            MenuItem {
                text: "2.0X"
                onTriggered: {
                    changeSpeed(2.0, this)
                }
            }

            MenuItem {
                text: "1.5X"
                onTriggered: {
                    changeSpeed(1.5, this)
                }
            }

            MenuItem {
                text: "1.0X"
                onTriggered: {
                    changeSpeed(1.0, this)
                }
            }

            MenuItem {
                text: "0.5X"
                onTriggered: {
                    changeSpeed(0.5, this)
                }
            }
        }
}
