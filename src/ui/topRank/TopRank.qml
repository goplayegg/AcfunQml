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
    property var rankChannels
    property int crtChannelID: 0

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
            refreshRank(tabBar.model.get(tabBar.currentIndex).value)
        }
    }

    function fillChannelList(){
        tabBar.model.clear()
        tabBar.model.append({ "name":"全站", "value": 0})
        for(var idx in rankChannels){
            tabBar.model.append({ "name":rankChannels[idx].channelName,
                                  "value":rankChannels[idx].channelId})
        }
        tabBar.currentIndex = -1
        tabBar.currentIndex = 0
    }

    function refreshRank(cid){
        crtChannelID = cid
        busyBox.running = true
        AcService.getRank(cid, cmbPeriod.crtPeriod, function(res){
            if(res.result !== 0){
                busyBox.running = false
                PopMsg.showError(js, mainwindowRoot)
                return
            }
            updateInfo(res)
        })
    }

    function refreshYangStar(){
        AcService.getYoungStar(cmbPeriod.crtPeriod, function(res){
            if(res.result !== 0){
                busyBox.running = false
                PopMsg.showError(js, mainwindowRoot)
                return
            }
            updateInfo(res)
        })
    }

    function refreshFastRise(){
        AcService.getFastRise(function(res){
            if(res.result !== 0){
                busyBox.running = false
                PopMsg.showError(js, mainwindowRoot)
                return
            }
            updateInfo(res)
        })
    }

    function refreshBananaRank(){
        AcService.getBananaRank(cmbPeriod.crtPeriod, function(res){
            if(res.result !== 0){
                busyBox.running = false
                PopMsg.showError(js, mainwindowRoot)
                return
            }
            updateInfo(res)
        })
    }

    function updateInfo(js){
        rankModel.clear()
        scrollbar.position = 0
        busyBox.running = false
        var cnt = js.rankList.length
        console.log("rank num:"+cnt)
        for(var i=0;i<cnt;++i){
            var jsCurRank = js.rankList[i]
            var videoArr = jsCurRank.videoList
            //console.log("videoArr:"+ JSON.stringify(videoArr))
            jsCurRank.vid = videoArr[0].id
            jsCurRank.userJson = JSON.stringify(jsCurRank.user)
            jsCurRank.tagListJson = JSON.stringify(jsCurRank.tagList)
            jsCurRank.videoListJson = JSON.stringify(jsCurRank.videoList)
            rankModel.append(jsCurRank)
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
                model.append({"name":"综合", "value":0})
                model.append({"name":"新秀", "value":1})
                model.append({"name":"上升最快", "value":2})
                model.append({"name":"香蕉榜", "value":3})
                model.append({"name":"文章", "value":4})
            }
            onCurrentIndexChanged: {
                if(empty())
                    return
                busyBox.running = true
                switch (currentIndex){
                case 0:
                    refreshRank(tabBar.model.get(tabBar.currentIndex).value)
                    break;
                case 1:
                    refreshYangStar();
                    break;
                case 2:
                    refreshFastRise();
                    break;
                case 3:
                    refreshBananaRank();
                    break;
                case 4:
                    refreshRank(63);
                    break;
                }
            }
        }
        TabBarAc {
            id: tabBar
            anchors.left: parent.left
            anchors.right: parent.right
            visible: tabRankType.currentIndex === 0
            onCurrentIndexChanged: {
                if(currentIndex >= 0){
                   refreshRank(tabBar.model.get(currentIndex).value)
                }
            }
        }
        GridView {
            id: cardView
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height-tabRankType.height-tabBar.height
            clip: true
            cellWidth: 205
            cellHeight: cellWidth
            ScrollBar.vertical : ScrollBar{
                id: scrollbar
                anchors.right: cardView.right
                width: 10
            }
            model: ListModel {
                id: rankModel
            }
            delegate: VideoInfoCard{
                    infoJs: model
                }
        }
    }
    ComboBox {
        id: cmbPeriod
        anchors.top: parent.top
        anchors.right: parent.right
        property string crtPeriod: "DAY"
        width: 50
        textRole: "key"
        currentIndex: 0
        indicator: null
        visible: tabRankType.currentIndex !== 2
        model: ListModel {
            ListElement { key: "日榜"; value: "DAY" }
            ListElement { key: "三日"; value: "THREE_DAYS" }
            ListElement { key: "周榜"; value: "WEEK" }
        }
        onCurrentIndexChanged: {
            if(empty()){
                return
            }
            crtPeriod = model.get(currentIndex).value
            refreshRank(crtChannelID)
        }
    }
}
