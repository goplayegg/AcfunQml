﻿//个人动态
import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import "qrc:///ui/components/card/"

Item{
    id:root

    ScrollView {
        id: scroll
        clip: true
        anchors.fill: parent

        Column {
            width: root.width
            spacing: 20

            Item {
                anchors.left: parent.left
                anchors.right: parent.right
                height: txTitle.height
                Text {
                    id: txTitle
                    height: 47
                    text: qsTr("动态")
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: AppStyle.font_xxxlarge
                    font.family: AppStyle.fontNameMain
                    font.weight: Font.Black
                }
                Switch {
                    id: swchVideoOnly
                    height: txTitle.height
                    text: qsTr("Video only")
                    anchors.right: parent.right
                    onCheckedChanged: {
                        if(!loaded)
                            return
                        refresh()
                        g_preference.setValue("circleOnlyGetVideo", checked)
                    }
                }
            }

            Waterfall {
                id: waterfall
                anchors.left: parent.left
                anchors.right: parent.right
                cardWidth: 300
                manuallyReLayout: true

                model: ListModel {
                    id: feedModel
                }
                delegate: CircleInfoCard {
                    feedInfo: model.info
                }
            }
        }

        Connections {
            target: scroll.ScrollBar.vertical
            function onPositionChanged() {
                if(1.0 === scroll.ScrollBar.vertical.position+scroll.ScrollBar.vertical.size){
                    getFeed()
                }
            }
            function onSizeChanged() {
                if(1.0 === scroll.ScrollBar.vertical.size){
                    getFeed()
                }
            }
        }
    }

    function refresh(){
        waterfall.clear()
        pcursor = ""
        getFeed()
    }

    function back(){

    }

    function empty(){
        return feedModel.count === 0
    }

    property string pcursor: ""
    function getFeed(){
        if(busyBox.running)
            return
        busyBox.running = true
        AcService.getFollowFeed(pcursor, 20, swchVideoOnly.checked?2:0, addFeed)
    }

    function addFeed(res){
        if(0 !== res.result){
            busyBox.running = false
            PopMsg.showError(res, mainwindowRoot)
        }else{
            pcursor = res.pcursor
            for(var idx in res.feedList){
                feedModel.append({info: res.feedList[idx]})
            }
            busyBox.running = false
            timerLayout.restart()
        }
    }

    Timer {
        id: timerLayout
        interval: 100//TODO时间做成可配置
        onTriggered: {
            waterfall.reLayout(waterfall.layoutedMaxIdx+1)
        }
    }

    property bool loaded: false
    Component.onCompleted: {
        swchVideoOnly.checked = Global.getBoolPref("circleOnlyGetVideo")
        loaded = true
    }
}
