import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"

Item{
    id:root

    signal openVideo(var js)
    function updateInfo(js){
        rankModel.clear()
        var cnt = js.rankList.length
        console.log("rank num:"+cnt)
        for(var i=0;i<cnt;++i){
            var jsCurRank = js.rankList[i]
            var videoArr = jsCurRank.videoList
            console.log("videoArr:"+ JSON.stringify(videoArr))
            jsCurRank.vid = videoArr[0].id
            rankModel.append(jsCurRank)
            console.log("rank append:"+js.rankList[i].title)
        }
    }
    ListModel {
        id:rankModel
    }
    GridView {
        anchors.fill: parent
        anchors.margins: 15
        clip: true
        cellWidth: 205
        cellHeight: cellWidth
        model:  rankModel
        delegate: VideoInfoCard{
                infoJs: model
            }
    }

}
