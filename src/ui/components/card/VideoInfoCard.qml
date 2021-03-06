﻿import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/global/"
import "qrc:///ui/global/libraries/functions.js" as FUN

Item {
    id:root
    width: 190
    height: width

    property var infoJs: ({})
    property bool noCount: false
    property alias containsMouse: mouseArea.containsMouse
    property alias coverImgUrl:imgCover.source

    Label{
        id: duration
        visible: containsMouse
        anchors.left: parent.left
        anchors.bottom: imgCover.bottom
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        padding: 5
        text: {
            if(infoJs.duration){
                var d = new Date()
                d.setTime(infoJs.duration)
                return FUN.fmtTime(d, "mm:ss")
            }
            if(infoJs.durationDisplay)
                return infoJs.durationDisplay
            if(infoJs.time){
                var dt = new Date()
                dt.setTime(infoJs.time)
                return qsTr("Posted") +"  "+ FUN.fmtTime(dt, "MM-dd")
            }
            duration.visible = false
            return ""
        }
        z:imgCover.z+1
        color: "white"
        background: Rectangle{
            color: "#313238"
            radius: 4
        }
    }

    AutoImage {
        id:imgCover
        height: 110
        width: parent.width
        source: infoJs.videoCover
    }

    Rectangle {
        color: "white"
        width: parent.width
        height: parent.height-imgCover.height
        anchors.top: imgCover.bottom
        //anchors.left: parent.left
        //anchors.right: parent.right
        Column{
            anchors.fill: parent
            anchors.topMargin: 10
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            clip: true
            spacing: 10
            width: parent.width
            Text {
                font.pointSize: 8
                color: "#A1A2A1"
                text: infoJs.userName+ " " + infoJs.createTime
            }
            Text {
                font.pointSize: 10
                font.bold: true
                text: infoJs.title
            }
            Row{
                visible: !noCount
                spacing: 5
                Image {
                    height: textPlayCnt.height
                    width: height
                    sourceSize: Qt.size(width, height)
                    source: "qrc:/assets/img/play.png"
                }
                Text {
                    id:textPlayCnt
                    font.pointSize: 8
                    text: infoJs.viewCountShow
                }
                Image {
                    height: textPlayCnt.height
                    width: height
                    sourceSize: Qt.size(width, height)
                    source: "qrc:/assets/img/coment.png"
                }
                Text {
                    font.pointSize: 8
                    text: infoJs.commentCountShow
                }
                Image {
                    height: textPlayCnt.height
                    width: height
                    sourceSize: Qt.size(width, height)
                    source: "qrc:/assets/img/banana.png"
                    visible: infoJs.bananaCountShow !== undefined
                }
                Text {
                    font.pointSize: 8
                    text: (infoJs.bananaCountShow !== undefined)?infoJs.bananaCountShow:""
                }
            }
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {          
            Global.openVideo({
                title        : infoJs.title,
                vid          : infoJs.vid,
                contentId    : infoJs.contentId,
                contentType  : infoJs.contentType,
                likeCountShow: infoJs.likeCountShow,
                bananaCountShow: infoJs.bananaCountShow,
                stowCount    : infoJs.stowCount,
                createTime   : infoJs.createTime,
                viewCountShow: infoJs.viewCountShow,
                danmakuCountShow: infoJs.danmakuCountShow,
                description     : infoJs.description,
                userJson        : infoJs.userJson,
                tagListJson     : infoJs.tagListJson,
                videoListJson   : infoJs.videoListJson,
                isThrowBanana   : infoJs.isThrowBanana,
                isFavorite      : infoJs.isFavorite,
                isLike          : infoJs.isLike
            })
        }
    }
}
