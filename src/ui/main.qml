import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12

import "qrc:///ui/components/"
//import "qrc:///ui/global/styles/"
//import "qrc:///ui/global/"
import "qrc:///ui/navigator/"
import "qrc:///ui/mainPage/"
import "qrc:///ui/videoPage/"
import "qrc:///ui/global/libraries/functions.js" as FUN

Window {
    id: mainwindow

    visible: true
    width: 640
    height: 600
    minimumWidth: 500
    minimumHeight: 600
    title: qsTr("AcfunQml")

    onClosing: {
        console.log("mainWindow closing")
        if(videoLoader.item){
            videoLoader.item.stop()
        }
    }

    property string videoPageSource: "qrc:/ui/videoPage/VideoPage.qml"
    property var stackViewLoader: [null, acMainLoader, articleLoader,
        circleLoader, topRankLoader, null, settingLoader, aboutLoader]
    property var stackViewSource: ["spliter",
        "qrc:/ui/mainPage/AcMainPage.qml",
        "qrc:/ui/article/article.qml",
        "qrc:/ui/circle/circle.qml",
        "qrc:/ui/topRank/topRank.qml",
        "spliter",
        "qrc:/ui/other/setting.qml",
        "qrc:/ui/other/about.qml"]
    Item {
        id: root
        anchors.fill: parent
        LeftNavig {
            id: navi
            z: content.z+1
            height: parent.height
            onPopupOpened: {
                root.enabled = !open
            }
            onLoginFinish: {
                stack.currentItem.item.refresh()
            }
            onCurIdxChanged: {
                stackViewLoader[curIdx].source = stackViewSource[curIdx]
                stack.replace(null, stackViewLoader[curIdx])//repRect.itemAt(curIdx))
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
        }

        Loader{
            id: acMainLoader
            Connections {
                target: acMainLoader.item
                onOpenVideo: {
                    busyBox.text = qsTr("Loading video ...")
                    busyBox.running = true
                    console.log("open video:"+JSON.stringify(js))
                    var d=new Date();
                    console.log(FUN.fmtTime(d, "hh:mm:ss"))
                    //videoLoader.source = videoPageSource//概率需要8秒
                    stack.push(videoLoader)
                    videoLoader.item.open(js)
                }
            }
            onLoaded: {
                console.log("acMainLoader Loaded")
                item.refresh()
            }
        }

        Loader{
            id: articleLoader
            Connections {
                target: articleLoader.item
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
            }
            onLoaded: {
                console.log("topRankLoader Loaded")
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
            anchors.centerIn: root
            visible: busyBox.running
        }

    }
}
