//个人动态
import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import "qrc:///ui/components/card/"

Item{
    id:root

    ScrollView {
        id: scroll
        clip: true
        anchors.fill: parent

        Column {
            width: root.width
            spacing: 20

            Item {
                anchors.left: parent.left
                anchors.right: parent.right
                height: txTitle.height
                Text {
                    id: txTitle
                    height: 47
                    text: qsTr("动态")
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: AppStyle.font_xxxlarge
                    font.family: AppStyle.fontNameMain
                    font.weight: Font.Black
                }
                Switch {
                    height: txTitle.height
                    text: qsTr("Video only")
                    anchors.right: parent.right
                }
            }

            Flow {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 8

                Repeater {
                    id: repCard
                    model: ListModel {
                        id: feedModel
                    }
                    CircleInfoCard {
                        feedInfoJson: model.info
                    }
                }
            }
        }
    }

    function refresh(){
        feedModel.clear()
        pcursor = ""
        getFeed()
    }

    function back(){

    }

    function empty(){
        return feedModel.count === 0
    }

    property string pcursor: ""
    function getFeed(){
        busyBox.running = true
        AcService.getFollowFeed(pcursor, 10, addFeed)
    }

    function addFeed(res){
        if(0 !== res.result){
            busyBox.running = false
            PopMsg.showError(res, mainwindowRoot)
        }else{
            for(var idx in res.feedList){
                feedModel.append({info: res.feedList[idx]})
            }
            busyBox.running = false
        }
    }
}
