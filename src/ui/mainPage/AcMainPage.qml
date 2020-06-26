import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/global/"

Item{
    id:root

    property var channelInfo
    signal openVideo(var js)
    function refresh(){
        busyBox.text = qsTr("Loading video list ...")
        busyBox.running = true
        AcService.getChannelList(function(res){
            if(0 !== res.result){
                busyBox.running = false
                PopMsg.showError(res, mainwindowRoot)
            }else{
                channelInfo = res
                changeChannel(res.channels[4].channelId)
            }
        })
    }

    function back(){

    }

    function changeChannel(cid){
        AcService.getChannelVideo(cid, 10, function(res){
            if(0 !== res.errorid){
                busyBox.running = false
                PopMsg.showError(res, mainwindowRoot)
            }else{
                var hot = res.vdata[1]
                var latest = res.vdata[4]
                rankModel.clear()
                updateInfo(hot)
                updateInfo(latest)
                busyBox.running = false
            }
        })
    }

    function updateInfo(js){
        var cnt = js.bodyContents.length
        console.log("video num:"+cnt)
        for(var i=0;i<cnt;++i){
            var jsCurVideo = js.bodyContents[i]
            var videoArr = jsCurVideo.videoList
            jsCurVideo.contentId = jsCurVideo.href
            jsCurVideo.duration = jsCurVideo.duration*1000
            jsCurVideo.videoCover = jsCurVideo.img[0]
            jsCurVideo.userName = jsCurVideo.user.name
            jsCurVideo.createTime = ""
            jsCurVideo.viewCountShow = jsCurVideo.visit.views
            jsCurVideo.commentCountShow = jsCurVideo.visit.comments
            jsCurVideo.bananaCountShow = jsCurVideo.visit.banana
            jsCurVideo.stowCount = jsCurVideo.visit.stows
            jsCurVideo.userJson = JSON.stringify(jsCurVideo.user)
            rankModel.append(jsCurVideo)
            console.log("rank append:"+ jsCurVideo.title)
        }
    }
    ListModel {
        id:rankModel
    }
    GridView {
        id: cardView
        anchors.fill: parent
        anchors.margins: 0
        clip: true
        cellWidth: 205
        cellHeight: cellWidth
        ScrollBar.vertical : ScrollBar{
            id: scrollbar
            anchors.right: cardView.right
            y: cardView.visibleArea.yPosition * cardView.height
            width: 10
            height: cardView.visibleArea.heightRatio * cardView.height
        }

        model:  rankModel
        delegate: VideoInfoCard{
                infoJs: model
            }
    }
}
