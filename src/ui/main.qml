import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QmlVlc 0.1

import "qrc:///ui/components/"
import "qrc:///ui/global/styles/"
//import "qrc:///ui/global/"
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

    property string videoPageSource: "qrc:/ui/videoPage/VideoPage.qml"
    property var stackViewLoader: [null, acMainLoader, articleLoader,
        circleLoader, topRankLoader, operationLoader, null, settingLoader, aboutLoader]
    property var stackViewSource: ["spliter",
        "qrc:/ui/mainPage/AcMainPage.qml",
        "qrc:/ui/article/Article.qml",
        "qrc:/ui/circle/Circle.qml",
        "qrc:/ui/topRank/TopRank.qml",
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
            source: videoPageSource
            Connections {
                target: videoLoader.item
            }
            function  openVideo(js) {
                busyBox.text = qsTr("Loading video ...")
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
            Connections {
                target: acMainLoader.item
                function  onOpenVideo(js) {
                    videoLoader.openVideo(js)
                }
            }
            onLoaded: {
                console.log("acMainLoader Loaded")
            }
        }

        Loader{
            id: articleLoader
            Connections {
                target: articleLoader.item
                function  onOpenVideo(js) {
                    videoLoader.openVideo(js)
                }
            }
            onLoaded: {
                console.log("articleLoader Loaded")
            }
        }

        Loader{
            id: circleLoader
            Connections {
                target: circleLoader.item
            }
            onLoaded: {
                console.log("circleLoader Loaded")
            }
        }

        Loader{
            id: topRankLoader
            Connections {
                target: topRankLoader.item
                function  onOpenVideo(js) {
                    videoLoader.openVideo(js)
                }
            }
            onLoaded: {
                console.log("topRankLoader Loaded")
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
            Connections {
                target: settingLoader.item
            }
            onLoaded: {
                console.log("settingLoader Loaded")
            }
        }

        Loader{
            id: aboutLoader
            Connections {
                target: aboutLoader.item
            }
            onLoaded: {
                console.log("aboutLoader Loaded")
            }
        }


        BusyIndicatorWithText {
            id: busyBox
            anchors.centerIn: mainwindowRoot
            visible: busyBox.running
        }

    }
}
