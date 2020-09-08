//近期活动
import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"

Item{
    id:root

    function empty(){
        return operationModel.count === 0
    }

    function refresh(){
        busyBox.text = qsTr("Loading events list ...")
        busyBox.running = true
        AcService.getOperationList(function(res){
            updateInfo(res)
        })
    }

    function back(){

    }

    function updateInfo(js){
        if(0 !== js.result){
            busyBox.running = false
            PopMsg.showError(js, mainwindowRoot)
            return
        }

        operationModel.clear()
        var cnt = js.operationList.length
        console.log("operationList num:"+cnt)
        for(var i=0;i<cnt;++i){
            operationModel.append(js.operationList[i])
            console.log("operationList append:"+js.operationList[i].title)
        }
        busyBox.running = false
    }

    ListModel {
        id:operationModel
    }
    GridView {
        id: cardView
        anchors.fill: parent
        anchors.margins: 0
        clip: true
        cellWidth: parent.width/2
        cellHeight: cellWidth*517/1066+30
        ScrollBar.vertical : ScrollBar{
            id: scrollbar
            anchors.right: cardView.right
            y: cardView.visibleArea.yPosition * cardView.height
            width: 10
            height: cardView.visibleArea.heightRatio * cardView.height
        }

        model:  operationModel
        delegate: Column {
            id: colOpeCard
            width: cardView.cellWidth-5
            height: cardView.cellHeight-5

            Image {
                id: img
                width: parent.width
                height: width*517/1066
                sourceSize.width: width
                sourceSize.height: height
                source: model.cover
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("open operation url:"+model.operationValue)
                        if(model.operationValue.substr(0,4) === "http")
                            Qt.openUrlExternally(model.operationValue)
                    }
                }
            }
            Flow {
                width: parent.width
                spacing: 5
                Label {
                    text: model.title
                    font.pixelSize: AppStyle.font_xlarge
                    font.family: AppStyle.fontNameMain
                    font.weight: Font.Medium
                }
                Label {
                    text: qsTr("%1 to %2").arg(model.beginTime).arg(model.endTime)
                    font.pixelSize: AppStyle.font_xlarge
                    font.family: AppStyle.fontNameMain
                    font.weight: Font.Medium
                }
            }
        }
    }
}

