import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/card/"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"

GridView {

    function open(){
        if(videoModel.count>0){
            busyBox.running = false
            return
        }
        AcService.bangumiMainPage(function(res){
            if(0 !== res.result){
                busyBox.running = false
                PopMsg.showError(res, mainwindowRoot)
            }else{
                busyBox.running = false
                //for(let i in res.favorite){
                //    videoModel.append({info:res.favorite[i]})
                //}
                for(let idx in res.data){
                    let contentList = res.data[idx].contentList
                    for(let ic in contentList){
                        videoModel.append({info:contentList[ic]})
                    }
                }

                return
                AcService.favoriteBangumi(10, "", function(res){

                })
            }
        })
    }

    id: control
    clip: true
    cellWidth: 205
    cellHeight: cellWidth
    ScrollBar.vertical : ScrollBar{
        id: scrollbar
        anchors.right: control.right
        width: 10
        onPositionChanged: {
            //console.log("scrollbar position:"+ position)
            if(1.0 === position+size){
            }
        }
        onSizeChanged: {
            //console.log("onSizeChanged size:"+ size)
            if(1.0 === size){
            }
        }
    }

    model: ListModel {
            id: videoModel
        }
    delegate: VideoInfoCard {
            infoJs: {
                "title": model.info.title,
                "contentId": model.info.href,
                "contentType": 1,//番
                "videoCover": model.info.coverUrl,
                "userName": "AcFun",
                "commentCountShow": model.info.commentCount,
                "createTime": "",
                "viewCountShow": model.info.viewCount,
                "danmakuCountShow": "",
                "description": "",
                "vid": model.info.videoId
            }
        }
}
