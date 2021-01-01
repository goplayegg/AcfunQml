import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QmlVlc 0.1

import "qrc:///ui/components/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"
import "qrc:///ui/navigator/"
import "qrc:///ui/mainPage/"
import "qrc:///ui/videoPage/"
import "qrc:///ui/global/libraries/functions.js" as FUN

//test
import "qrc:///ui/components/emot"
import "qrc:///test"

Window {
    id: mainwindow

    visible: true
    width: 990
    height: 710
    minimumWidth: 500
    minimumHeight: 600
    title: qsTr("AcfunQml")

    VlcConfig {
        id: vlcConfig
        Component.onCompleted: {
            var hardDec = g_preference.value("hardDec")
            var enable = true
            if(undefined !== hardDec){
                enable = hardDec === "true"
            }
            console.log("VlcConfig enable hard decode:"+enable)
            vlcConfig.enableHardDecode(enable)

            var theme = g_preference.value("theme")
            if(undefined !== theme) {
                AppStyle.currentTheme = parseInt(theme)
            }
        }
    }

    onClosing: {
        console.log("mainWindow closing")
        FullScreenWindow.close()
        if(videoLoader.item){
            videoLoader.item.stop()
        }
    }
    onActiveChanged: {
        if(active && FullScreenWindow.visible){
            FullScreenWindow.raise()
        }
    }

    property var stackViewLoader: [null, acMainLoader, articleLoader,
        circleLoader, topRankLoader, msgLoader, operationLoader, null, settingLoader, aboutLoader]
    property var stackViewSource: ["spliter",
        "qrc:/ui/mainPage/AcMainPage.qml",
        "qrc:/ui/article/Article.qml",
        "qrc:/ui/circle/Circle.qml",
        "qrc:/ui/topRank/TopRank.qml",
        "qrc:/ui/msg/MyMsg.qml",
        "qrc:/ui/other/Operation.qml",
        "spliter",
        "qrc:/ui/other/Setting.qml",
        "qrc:/ui/other/About.qml"]
    Item {
        id: mainwindowRoot
        anchors.fill: parent
        LeftNavig {
            id: navi
            z: content.z+1
            height: parent.height
            onPopupOpened: {
                mainwindowRoot.enabled = !open
            }
            onLoginFinish: {
                //TODOstack.currentItem.item.refresh()
            }
            onCurIdxChanged: {
                if(stack.currentItem)
                    stack.currentItem.item.back()
                stackViewLoader[curIdx].source = stackViewSource[curIdx]
                stack.replace(null, stackViewLoader[curIdx])
                if(stack.currentItem.item.empty()){
                   stack.currentItem.item.refresh()
                }
            }
        }

        Item {
            id: content
            anchors.leftMargin: 45
            anchors.left: navi.right
            anchors.rightMargin: 15
            anchors.right: parent.right
            height: parent.height

            SearchToolBar {
                id: tool
                anchors.top: parent.top
                anchors.topMargin: 30
                width: parent.width
                backEnable: stack.depth>1
                onRefresh: {
                    //TestWindow.open()
                    //PopEmot.parent = mainwindowRoot
                    //PopEmot.open()
                    stack.currentItem.item.refresh()
                }
                onBack: {
                    stack.currentItem.item.back()
                    stack.pop()
                }
                onSearch: {
                    searchLoader.openSearchPage(keyword)
                }
            }

            StackView {
                id: stack
                width: parent.width
                anchors.topMargin: 15
                anchors.top: tool.bottom
                anchors.bottom: parent.bottom

                Component.onCompleted: {
                    stackViewLoader[1].source = stackViewSource[1]
                    initialItem =  stackViewLoader[1].item
                }

                replaceEnter:Transition {
                    PropertyAnimation {
                        property: "opacity"
                        from: 0
                        to:1
                        duration: 200
                    }
                }

                replaceExit:Transition {
                    PropertyAnimation {
                        property: "opacity"
                        from: 0
                        to:1
                        duration: 20
                    }
                }
            }
        }

        Loader{
            id: videoLoader
            asynchronous: true
            source: "qrc:/ui/videoPage/VideoPage.qml"
            function  openVideo(js) {
                busyBox.running = true
                console.log("open video:"+JSON.stringify(js))
                var d=new Date();
                console.log(FUN.fmtTime(d, "hh:mm:ss"))
                stack.push(videoLoader)
                videoLoader.item.open(js)
            }
        }

        Loader{
            id: acMainLoader
            onLoaded: {
                console.log("acMainLoader Loaded")
            }
        }

        Loader{
            id: articleLoader
            onLoaded: {
                console.log("articleLoader Loaded")
            }
        }

        Loader{
            id: circleLoader
            onLoaded: {
                console.log("circleLoader Loaded")
            }
        }

        Loader{
            id: topRankLoader
            onLoaded: {
                console.log("topRankLoader Loaded")
            }
        }

        Loader{
            id: msgLoader
            onLoaded: {
                console.log("msgLoader Loaded")
            }
        }

        Loader{
            id: operationLoader
            onLoaded: {
                console.log("operationLoader Loaded")
            }
        }

        Loader{
            id: settingLoader
            onLoaded: {
                console.log("settingLoader Loaded")
            }
        }

        Loader{
            id: aboutLoader
            onLoaded: {
                console.log("aboutLoader Loaded")
            }
        }

        Loader{
            id: favoriteLoader
            asynchronous: true
            source: "qrc:/ui/other/FavoriteListPage.qml"
            function open(){
                stack.push(favoriteLoader)//TODO 先将原来的pop掉
                favoriteLoader.item.refresh()
            }
        }

        Loader{
            id: pocketLoader
            asynchronous: true
            source: "qrc:/ui/other/PocketListPage.qml"
            function open(){
                stack.push(pocketLoader)
                pocketLoader.item.refresh()
            }
        }

        Loader{
            id: historyLoader
            asynchronous: true
            source: "qrc:/ui/other/HistoryListPage.qml"
            function open(){
                stack.push(historyLoader)
                historyLoader.item.refresh()
            }
        }

        Loader{
            id: searchLoader
            asynchronous: true
            source: "qrc:/ui/other/SearchResult.qml"
            function openSearchPage(keyword){
                console.log("search key:"+keyword)
                stack.push(searchLoader)
                searchLoader.item.search(keyword)
            }
        }

        Loader{
            id: circleDetailLoader
            asynchronous: true
            source: "qrc:/ui/circle/CircleDetail.qml"
            function openPage(info, byId){
                console.log("open circle detail..")
                stack.push(circleDetailLoader)
                if(byId)
                    circleDetailLoader.item.openById(info)
                else
                    circleDetailLoader.item.open(info)
            }
        }

        Loader{
            id: userLoader
            z: navi.z+1
            width: 340
            height: navi.height
            visible: status === Loader.Ready
            function openPage(info){
                if(status !== Loader.Ready){
                    source = "qrc:/ui/user/User.qml"
                    console.log("load user page.....")
                }
                userLoader.item.open(info)
            }
        }

        Connections {
            target: Global
            function onOpenCircleDetail(info, byId) {
                circleDetailLoader.openPage(info, byId)
            }
            function onOpenVideo(js) {
                videoLoader.openVideo(js)
            }
            function onOpenUser(js) {
                userLoader.openPage(js)
            }
            function onOpenArticle(js) {
                navi.curIdx = 2
                articleLoader.item.open(js)
            }
            function onLogout(){
                navi.logout()
            }
            function onOpenOther(idx){
                switch(idx){
                case 0://收藏
                    favoriteLoader.open()
                    break;
                case 1://稍后再看
                    pocketLoader.open()
                    break;
                case 2://历史
                    historyLoader.open()
                    break;
                case 3://搜索
                    searchLoader.openSearchPage("")
                    break;
                }
            }
        }

        Connections {
            target: g_commonTools
            function onExternalCmd(json){
                var ms = 0
                if(videoLoader.state === Loader.Ready){
                    console.log("onExternalCmd, video ready!")
                }else{
                    ms = 3000
                }
                var vCmd = JSON.parse(json)
                if(vCmd.type === "video"){
                    timerDoLater.doLater(ms, {contentId: vCmd.acId}, function(val){
                                                    videoLoader.openVideo(val)})
                }else{
                    console.log("not support!Cmd:"+json)
                }
            }
        }

        Timer {
            id: timerDoLater
            property var funCb
            property var cbVal
            function doLater(ms, val, cb){
                if(ms === 0){
                    cb(val)
                    return
                }
                interval = ms
                funCb = cb
                cbVal = val
                restart()
            }
            onTriggered: {
                funCb(cbVal)
            }
        }

        BusyIndicatorWithText {
            id: busyBox
            anchors.centerIn: mainwindowRoot
            text: qsTr("Loading...")
            visible: busyBox.running
        }

    }
}
