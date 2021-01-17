import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/card/"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"

Item {

    property bool bangumiPageLoaded: false
    function open(){
        if(bangumiPageLoaded){
            busyBox.running = false
            return
        }
        AcService.bangumiMainPage(function(res){
            if(0 !== res.result){
                busyBox.running = false
                PopMsg.showError(res, mainwindowRoot)
            }else{
                bangumiPageLoaded = true
                busyBox.running = false
                //for(let i in res.favorite){
                //    videoModel.append({info:res.favorite[i]})
                //}
                for(let idx in res.data){
                    if("slideBanner" === res.data[idx].moduleLayout)
                        slideBanner.set(res.data[idx])
                    else if(15 === res.data[idx].moduleId){//热播推荐
                        let hotList = res.data[idx].contentList
                        for(let ih in hotList){
                            hotModel.append({info:hotList[ih]})
                        }
                    }else{
                        let contentList = res.data[idx].contentList
                        for(let ic in contentList){
                            bangumiModel.append({info:contentList[ic]})
                        }
                    }
                }

                return
                AcService.favoriteBangumi(10, "", function(res){

                })
            }
        })
    }

    property bool smallMode: width<1030
    SwipeCircle {
        id: slideBanner
        width: smallMode?620:800
        height: 250
        model: ListModel {
            id: modelBanner
        }
        delegate: Image {
            source: model.info.coverUrl
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: slideBanner.paused = true
                onExited: slideBanner.paused = false
                onClicked: {
                    console.log("clicked banner:"+model.info.title)
                    Global.openVideo({
                                         vid          : model.info.videoId,
                                         contentId    : model.info.href,
                                         contentType  : 1
                                     })
                }
            }
        }
        function set(js){
            for(let i in js.contentList){
                modelBanner.append({info:js.contentList[i]})
            }
        }
    }

    GridView {
        id: hots
        anchors.right: parent.right
        clip: true
        cellWidth: 205
        cellHeight: 125
        ScrollBar.vertical : ScrollBar{
            policy: smallMode?ScrollBar.AlwaysOn:ScrollBar.AsNeeded
        }
        model: ListModel {
                id: hotModel
            }
        delegate: BangumiCardHor {
                infoJs: model.info
            }
    }

    GridView {
        anchors.top: smallMode?hots.bottom:slideBanner.bottom
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        width: parent.width
        clip: true
        cellWidth: 205
        cellHeight: 300
        ScrollBar.vertical : ScrollBar{}
        model: ListModel {
                id: bangumiModel
            }
        delegate: BangumiCard {
                infoJs: model.info
            }
    }

    state: smallMode?"vertical":"right"
    states: [
        State {
            name: "vertical"
            PropertyChanges {
                target: hots
                anchors.top: slideBanner.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 0
                height: hots.cellHeight
            }
        },
        State {
            name: "right"
            PropertyChanges {
                target: hots
                anchors.top: slideBanner.top
                anchors.topMargin: 0
                anchors.left: slideBanner.right
                anchors.leftMargin: 20
                height: slideBanner.height
            }
        }
    ]
}
