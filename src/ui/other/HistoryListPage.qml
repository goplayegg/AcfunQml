import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/card/"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/libraries/functions.js" as FUN

Item{
    id:root

    function empty(){
        return false
    }

    function refresh(){
        pcursor = ""
        search()
    }

    function back(){
    }

    property string pcursor: ""
    function search(){
        if(busyBox.running)
            return
        busyBox.running = true
        AcService.watchHistoryList(pcursor, 20, function(res){
            if("" === pcursor)
                histModel.clear()
            updateInfo(res)
        });
    }

    function updateInfo(js){
        if(0 !== js.result){
            busyBox.running = false
            PopMsg.showError(js, mainwindowRoot)
            return
        }
        pcursor = js.pcursor
        var cnt = js.histories.length
        console.log("hist result num:"+cnt)
        for(var i=0;i<cnt;++i){
            histModel.append({"info":js.histories[i]})
            console.log("hist result append:"+js.histories[i].title)
        }
        busyBox.running = false
    }

    GridView {
        id: cardView
        anchors.fill: parent
        anchors.margins: 0
        clip: true
        cellWidth: 205
        cellHeight: 205
        ScrollBar.vertical : ScrollBar{
            id: scrollbar
            anchors.right: cardView.right
            width: 10
            onPositionChanged: {
                //console.log("scrollbar position:"+ position)
                if(1.0 === position+size){
                    search()
                }
            }
            onSizeChanged: {
                //console.log("onSizeChanged size:"+ size)
                if(1.0 === size){
                    search()
                }
            }
        }

        model: ListModel {
            id: histModel
        }
        delegate: VideoInfoCard {
            noCount: true
            infoJs: {
                "title": model.info.title,
                "contentId": model.info.resourceId,
                "contentType": 2,
                "videoCover": model.info.cover,
                "durationDisplay": model.info.playedSecondsShow,
                "userName": model.info.user.name,
                "commentCountShow": model.info.commentCountShow,
                "createTime": FUN.fmtMs2TimeStr(model.info.browseTime),
                "viewCountShow": model.info.viewCountShow,
                "danmakuCountShow": "",
                "description": model.info.intro
            }
        }
    }
}

