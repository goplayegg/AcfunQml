import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/global/"

Item{
    id:root

    signal openVideo(var js)
    //先作为显示自己投稿的页面
    function refresh(){
        busyBox.text = qsTr("Loading artical list ...")
        busyBox.running = true
        AcService.getUpVideoList(Global.userInfo.userid, function(res){
            updateInfo(res)
        })
    }

    function back(){

    }

    function updateInfo(js){
        if(0 !== js.result){
            busyBox.running = false
            PopMsg.showError(js, mainwindowRoot)
            return
        }

        rankModel.clear()
        var cnt = js.feed.length
        console.log("rank num:"+cnt)
        for(var i=0;i<cnt;++i){
            var jsCurRank = js.feed[i]
            jsCurRank.vid = jsCurRank.videoList[0].id
            jsCurRank.duration = jsCurRank.durationMillis
            jsCurRank.videoCover = jsCurRank.coverUrl
            jsCurRank.userName = jsCurRank.user.name
            jsCurRank.contentId = jsCurRank.dougaId
            jsCurRank.contentType = 2
            jsCurRank.userJson = JSON.stringify(jsCurRank.user)
            jsCurRank.tagListJson = JSON.stringify(jsCurRank.tagList)
            rankModel.append(jsCurRank)
            console.log("rank append:"+jsCurRank.title)
        }
        busyBox.running = false
    }

    Image {
        anchors.fill: parent
        source: "qrc:/assets/img/bk/bog.jpg"
        fillMode: Image.PreserveAspectCrop
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
