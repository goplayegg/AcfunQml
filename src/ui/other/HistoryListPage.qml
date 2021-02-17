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
        AcService.watchHistoryList(pcursor, 40, function(res){
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
            histModel.append({"info":js.histories[i],
                             "type":js.histories[i].resourceType})
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
        delegate: Item {
            id: deleCard
            width: 190
            height: 190
            Component {
                id: cmpVideo
                VideoInfoCard {
                    noCount: true
                    infoJs: model.type === 1 ?
                                {
                                   "title": model.info.title,
                                   "contentId": model.info.resourceId,
                                   "contentType": 1,//番
                                   "videoCover": model.info.cover,
                                   "durationDisplay": model.info.playedSecondsShow,
                                   "userName": "AcFun",
                                   "commentCountShow": model.info.commentCountShow,
                                   "createTime": FUN.fmtMs2TimeStr(model.info.browseTime),
                                   "viewCountShow": model.info.viewCount,
                                   "danmakuCountShow": "",
                                   "description": model.info.bangumiItemEpisodeName,
                                   "vid": model.info.videoId
                                }
                                :
                                {
                                    "title": model.info.title,
                                    "contentId": model.info.resourceId,
                                    "contentType": 2,//视频
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
            Component {
                id: cmpArticle
                ArticleCardSquare {
                    articleJson: {
                        "userImg": model.info.user.headUrl,
                        "userId": model.info.user.id,
                        "userName": model.info.user.name,
                        "viewCountInfo": model.info.viewCountShow,
                        "commentCountInfo": model.info.commentCountShow,
                        "channelName": "",
                        "title": model.info.title,
                        "ctime": 0,
                        "contentId": model.info.resourceId
                    }
                }
            }
            Loader {
                sourceComponent: {
                    if(model.type === 1)//bangumi番
                        return cmpVideo;
                    if(model.type === 2)//video
                        return cmpVideo;
                    if(model.type === 3)//article
                        return cmpArticle;
                    console.log("not supprot historu type:"+model.type)
                    return cmpVideo;
                }
            }
        }
    }
}

