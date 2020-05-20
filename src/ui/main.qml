import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12

import AcfunQml 1.0
import "qrc:///ui/components/" as COM
import "qrc:///ui/global/styles/"
import "qrc:///ui/player/" as PLAYER
import "qrc:///ui/global/"
import "qrc:///ui/navigator/"
import "qrc:///ui/mainPage/"
import "qrc:///ui/videoPage/"

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
    property var stackViewLoader: [null, acMainLoader, acMainLoader2, acMainLoader3]
    property var stackViewSource: ["",
        "qrc:/ui/mainPage/AcMainPage.qml",
        "qrc:/ui/mainPage/AcMainPage.qml",
        "qrc:/ui/mainPage/AcMainPage.qml"]
    Item {
        id: root
        anchors.fill: parent
        LeftNavig {
            id: navi
            height: parent.height
            onPopupOpened: {
                root.enabled = !open
            }
            onLoginFinish:{
                stack.currentItem.item.refresh()
            }
            onCurIdxChanged: {
                stackViewLoader[curIdx].source = stackViewSource[curIdx]
                stack.replace(null, stackViewLoader[curIdx])//repRect.itemAt(curIdx))
            }
        }

        StackView {
            id:stack
            anchors.left: navi.right
            anchors.right: parent.right
            //anchors.leftMargin: 100
            height: parent.height

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

        Loader{
            id: videoLoader
            visible: false
            z:9
            anchors.fill: parent
            Connections {
                target: videoLoader.item
            }
        }

        Loader{
            id: acMainLoader
            //anchors.fill: parent
            Connections {
                target: acMainLoader.item
                onOpenVideo: {
                    console.log("open video:"+JSON.stringify(js))
                    videoLoader.source = videoPageSource
                    videoLoader.visible = true
                    videoLoader.item.open(js)
                }
            }
            onLoaded: {
                console.log("open acMainLoader1")
            }
        }

        Loader{
            id: acMainLoader2
            //anchors.fill: parent
            Connections {
                target: acMainLoader2.item
                onOpenVideo: {
                    console.log("open video:"+JSON.stringify(js))
                    videoLoader.source = videoPageSource
                    videoLoader.visible = true
                    videoLoader.item.open(js)
                }
            }
            onLoaded: {
                console.log("open acMainLoader2")
            }
        }

        Loader{
            id: acMainLoader3
            //anchors.fill: parent
            Connections {
                target: acMainLoader3.item
                onOpenVideo: {
                    console.log("open video:"+JSON.stringify(js))
                    videoLoader.source = videoPageSource
                    videoLoader.visible = true
                    videoLoader.item.open(js)
                }
            }
            onLoaded: {
                console.log("open acMainLoader3")
            }
        }
    }
}
