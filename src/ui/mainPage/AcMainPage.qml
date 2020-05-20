import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/global/"

Item{
    id:root

    signal openVideo(var js)
    function refresh(){
        AcService.getRank(function(res){
            updateInfo(res)
        })
    }

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


    Button{
        anchors.topMargin: 50
        id:btnTest
        anchors.top: parent.bottom
        anchors.right: parent.right
        height: 50
        width: 50
        text:qsTr("Rank")
        //textColor: "white"
        //color: AppStyle.accentColor
        onClicked: {
            videoPage.stop()
            videoPage.visible = false
            acMain.visible = true
            acMain.refresh()
        }
    }

    Button{
        anchors.topMargin: 50
        id:btnBack
        anchors.top: btnTest.bottom
        anchors.right: parent.right
        height: 50
        width: 50
        text:qsTr("Back")
        //textColor: "white"
        //color: AppStyle.accentColor
        onClicked: {
            videoPage.stop()
            videoPage.visible = false
            acMain.visible = true
        }
    }
}
