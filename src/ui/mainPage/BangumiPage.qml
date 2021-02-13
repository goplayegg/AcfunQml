import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/card/"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"

ScrollView {
    clip: true
    ScrollBar.vertical.policy: ScrollBar.AlwaysOn
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
                setModel(favoriteModel, res.favorite)
                for(let idx in res.data){
                    if("slideBanner" === res.data[idx].moduleLayout){
                        setModel(modelBanner, res.data[idx].contentList)
                    }
                    else if(15 === res.data[idx].moduleId){//热播推荐
                        setModel(hotModel, res.data[idx].contentList)
                    }
                    else if("horizontalArrange" === res.data[idx].moduleLayout){//其他横屏
                        if(idx == 1 && hotModel.count === 0)
                            setModel(hotModel, res.data[idx].contentList)
                        else
                            setModel(bangumiHorModel, res.data[idx].contentList)
                    }else{
                        setModel(bangumiModel, res.data[idx].contentList)
                    }
                }
            }
        })
    }
    function setModel(model, list){
        for(let i in list){
            model.append({info:list[i]})
        }
    }

    function refreshFavorite(){
        busyBox.running = true
        AcService.favoriteBangumi(50, "", function(res){
            if(0 !== res.result){
                busyBox.running = false
                PopMsg.showError(res, mainwindowRoot)
            }else{
                busyBox.running = false
                favoriteModel.clear()
                setModel(favoriteModel, res.feeds)
            }
        })
    }

    property bool smallMode: width<1030
    Item {
        id: contentScroll
        anchors.left: parent.left
        anchors.right: parent.right

    SwipeCircle {
        id: slideBanner
        width: smallMode?620:800
        height: smallMode?200:250
        model: ListModel {
            id: modelBanner
        }
        delegate: Image {
            source: model.info.coverUrl
            visible: SwipeView.isCurrentItem || SwipeView.isPreviousItem
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
    }

    GridView {
        id: hots
        anchors.right: parent.right
        clip: true
        cellWidth: 205
        cellHeight: 125
        ScrollBar.vertical : ScrollBar{
            anchors.right: parent.right
            anchors.rightMargin: 8
            policy: hots.contentHeight>hots.height?ScrollBar.AlwaysOn:ScrollBar.AsNeeded
        }
        model: ListModel {
                id: hotModel
            }
        delegate: BangumiCardHor {
                infoJs: model.info
            }
    }

    ListView {
        id: favorite
        anchors.top: smallMode?hots.bottom:slideBanner.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.right: parent.right
        height: count>0?125:0
        spacing: 15
        orientation: Qt.Horizontal
        ScrollBar.horizontal : ScrollBar{
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -5
            policy: favorite.contentWidth>favorite.width?ScrollBar.AlwaysOn:ScrollBar.AsNeeded
        }
        model: ListModel {
                id: favoriteModel
            }
        delegate: BangumiCardHor {
                infoJs: {
                    "coverUrl": model.info.coverUrls[0],
                    "noStow": true,
                    "title": model.info.showSerialStatus,
                    "videoId": 0,
                    "href": model.info.id
                }
            }
    }

    Grid {
        id: girdBangumi
        anchors.top: favorite.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 15
        property int cellWidth: 190
        columns: width/(cellWidth+spacing)
        Repeater{
            model: ListModel {
                    id: bangumiModel
                }
            delegate: BangumiCard {
                    width: girdBangumi.cellWidth
                    infoJs: model.info
                }
        }
    }
    Grid {
        id: girdBangumiHor
        anchors.top: girdBangumi.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 15
        property int cellWidth: 190
        columns: width/(cellWidth+spacing)
        Repeater{
            model: ListModel {
                    id: bangumiHorModel
                }
            delegate: VideoInfoCard {
                    width: girdBangumiHor.cellWidth
                    infoJs:
                    {
                        "title": model.info.title,
                        "contentId": model.info.href,
                        "contentType": 2,
                        "videoCover": model.info.coverUrl,
                        "userName": "",
                        "commentCountShow": model.info.commentCount,
                        "createTime": "",
                        "viewCountShow": model.info.playCount,
                        "danmakuCountShow": "",
                        "description": ""
                    }
                }
        }
    }

    property int staticHeight: slideBanner.height + 10 + favorite.height + 10 + girdBangumi.height + 10 + girdBangumiHor.height
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
            PropertyChanges {
                target: contentScroll
                implicitHeight: staticHeight + 10 + hots.height
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
            PropertyChanges {
                target: contentScroll
                implicitHeight: staticHeight
            }
        }
    ]
    }
}
