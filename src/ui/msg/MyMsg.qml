import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/card/"
import "qrc:///ui/global/"

Item{
    id:root

    function empty(){
        return 0 === tabBar.model.count
    }
    function back(){
    }

    function refresh(){
        busyBox.text = qsTr("Loading...")
        busyBox.running = true
        if(undefined === rankChannels){
            AcService.getRankChannelList(function(res){
                if(res.result !== 0){
                    busyBox.running = false
                    PopMsg.showError(js, mainwindowRoot)
                    return
                }
                rankChannels = res.channels
                fillChannelList()
            })
        }else{
            refreshMsg()
        }
    }

    function refreshMsg(){

    }

    function updateInfo(js){
        msgModel.clear()
        scrollbar.position = 0
        busyBox.running = false
        var cnt = js.rankList.length
        for(var i=0;i<cnt;++i){
            var jsCurRank = js.rankList[i]
            var videoArr = jsCurRank.videoList
            //console.log("videoArr:"+ JSON.stringify(videoArr))
            jsCurRank.vid = videoArr[0].id
            jsCurRank.userJson = JSON.stringify(jsCurRank.user)
            jsCurRank.tagListJson = JSON.stringify(jsCurRank.tagList)
            jsCurRank.videoListJson = JSON.stringify(jsCurRank.videoList)
            msgModel.append(jsCurRank)
            console.log("rank append:"+js.rankList[i].title)
        }
    }
    Column {
        anchors.fill: parent
        TabBarAc {
            id: tabRankType
            anchors.left: parent.left
            anchors.right: parent.right
            Component.onCompleted: {
                model.append({"name":qsTr("消息"), "value":0})
                model.append({"name":qsTr("评论"), "value":1})
                model.append({"name":qsTr("点赞"), "value":2})
                model.append({"name":qsTr("@我的"), "value":3})
                model.append({"name":qsTr("礼物"), "value":4})
            }
            onCurrentIndexChanged: {
                if(empty())
                    return
                busyBox.running = true
                switch (currentIndex){
                case 0:
                    refreshMsg()
                    break;
                case 1:
                    break;
                case 2:
                    break;
                case 3:
                    break;
                case 4:
                    break;
                }
            }
        }
        ScrollView {
            id: scroll
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height-tabRankType.height
            clip: true
            Waterfall {
                id: wf
                width: parent.width
                cardWidth: 140
                model: ListModel {
                    id: msgModel
                }
                delegate: Item{
                    height: model.h
                }
            }
        }

        Connections {
            target: scroll.ScrollBar.vertical
            function onPositionChanged() {
                if(0.99 < target.position+target.size){
                    console.log("scrollbar position:"+ target.position)
                    //appendCard(10)
                }
            }
            function onSizeChanged() {
                if(1.0 === target.size){
                    console.log("scrollbar size:"+ target.size)
                    //appendCard(30)
                }
            }
        }
    }
}
