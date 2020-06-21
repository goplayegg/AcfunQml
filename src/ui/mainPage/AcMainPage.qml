import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/global/"

Item{
    id:root

    signal openVideo(var js)
    function refresh(){
        busyBox.text = qsTr("Loading video list ...")
        busyBox.running = true
        AcService.getRank(function(res){
            updateInfo(res)
        })
    }

    function back(){

    }

    function updateInfo(js){
        rankModel.clear()
        var cnt = js.rankList.length
        console.log("rank num:"+cnt)
        for(var i=0;i<cnt;++i){
            var jsCurRank = js.rankList[i]
            var videoArr = jsCurRank.videoList
            //console.log("videoArr:"+ JSON.stringify(videoArr))
            jsCurRank.vid = videoArr[0].id
            jsCurRank.userJson = JSON.stringify(jsCurRank.user)
            rankModel.append(jsCurRank)
            console.log("rank append:"+js.rankList[i].title)
        }
        busyBox.running = false
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
