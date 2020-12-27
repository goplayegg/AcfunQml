import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/card/"
import "qrc:///ui/components/btn/"
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
        if(busyBox.running || "no_more" === pcursor)
            return
        busyBox.running = true
        AcService.waitingList(pcursor, 20, function(res){
            if("" === pcursor)
                laterModel.clear()
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
        var cnt = js.list.length
        console.log("later result num:"+cnt)
        for(var i=0;i<cnt;++i){
            laterModel.append({"info":js.list[i]})
            console.log("later result append:"+js.list[i].caption)
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
            id: laterModel
        }
        delegate: VideoInfoCard {
            infoJs: {
                "title": model.info.caption,
                "contentId": model.info.contentId,
                "contentType": model.info.type,
                "videoCover": model.info.coverUrl,
                "durationDisplay": model.info.playDuration,
                "userName": model.info.user.name,
                "commentCountShow": model.info.commentCount,
                "createTime": model.info.contributeTime,
                "viewCountShow": model.info.viewCountShow,
                "danmakuCountShow": model.info.danmakuCountShow,
                "bananaCountShow":model.info.bananaCountShow,
                "description": model.info.description
            }

            RoundButton {
                id: btnDelete
                visible: parent.containsMouse || hovered
                property bool deleted: false
                onDeletedChanged: parent.coverImgUrl = btnDelete.deleted?"qrc:/assets/img/bk/acShock.png":model.info.coverUrl
                icon.name: deleted?AppIcons.mdi_restart :AppIcons.mdi_delete_outline
                size: 30
                textColor: AppStyle.foregroundColor
                anchors.right: parent.right
                anchors.rightMargin: 4
                y: 4
                onClicked: {
                    if(deleted){
                        AcService.addWaiting(model.info.contentId, model.info.type, function(res){
                            if(res.result === 0)
                                deleted = false
                        });
                    }else{
                        AcService.cancelWaiting(model.info.contentId, model.info.type, function(res){
                            if(res.result === 0)
                                deleted = true
                        });
                    }
                }
            }
        }
    }
}

