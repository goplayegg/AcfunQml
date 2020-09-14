import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"

Item{
    id:root

    signal openVideo(var js)
    function empty(){
        return false
    }

    function refresh(){
    }

    function back(){
    }

    function search(keyword, pCursor = 0){
        busyBox.text = qsTr("Loading search result ...")
        busyBox.running = true
        if(0 === pCursor)
            resultModel.clear()
        AcService.search(keyword, pCursor, function(res){
            updateInfo(res)
        })
    }

    function updateInfo(js){
        if(0 !== js.result){
            busyBox.running = false
            PopMsg.showError(js, mainwindowRoot)
            return
        }

        var cnt = js.itemList.length
        console.log("search result num:"+cnt)
        for(var i=0;i<cnt;++i){
            resultModel.append({"info":js.itemList[i],
                                "type":js.itemList[i].itemType})
            console.log("search result append:"+js.itemList[i].title)
        }
        busyBox.running = false
    }

    ListModel {
        id:resultModel
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
        }

        model:  resultModel
        delegate: Column {
            id: colOpeCard
            width: 190
            height: 190

            Image {
                id: img
                width: parent.width
                height: 110
                sourceSize.width: width
                sourceSize.height: height
                source: model.info.coverUrl
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("open operation url:"+model.info.title)
                    }
                }
            }
            Label {
                text: model.info.title
            }
        }
    }
}

