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
        pcursor = 0
        search()
    }

    function back(){
    }

    property var pcursor: 0
    function search(){
        if(busyBox.running)
            return
        busyBox.running = true
        AcService.favoriteVideoList(pcursor, 20, function(res){
            if(0 === pcursor)
                favModel.clear()
            updateInfo(res)
        });
    }

    function updateInfo(js){
        if(0 !== js.result){
            busyBox.running = false
            PopMsg.showError(js, mainwindowRoot)
            return
        }
        pcursor = js.cursor
        var cnt = js.favoriteList.length
        console.log("favorite result num:"+cnt)
        for(var i=0;i<cnt;++i){
            favModel.append({"info":js.favoriteList[i]})
            console.log("favorite result append:"+js.favoriteList[i].contentTitle)
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
            id: favModel
        }
        delegate: VideoInfoCard {
            infoJs: {
                "title": model.info.contentTitle,
                "contentId": model.info.contentId,
                "contentType": 2,
                "videoCover": model.info.contentImg,
                "durationDisplay": model.info.channelInfo.channelName,
                "userName": model.info.userName,
                "commentCountShow": model.info.comments,
                "createTime": FUN.fmtMs2TimeStr(model.info.contentCreateTime),
                "viewCountShow": model.info.views,
                "danmakuCountShow": "",
                "description": model.info.contentDesc
            }
        }
    }
}

