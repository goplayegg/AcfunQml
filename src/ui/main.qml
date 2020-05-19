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

    onClosing:{
        console.log("mainWindow closing")
        videoPage.stop()
    }

    Row{
        id: rowMain
        anchors.fill: parent
        z:1

        LeftNavig{
            id: navi
            height: parent.height
            onPopupOpened: {
                rowMain.enabled = !open
            }
            onGetRankFinish: {

            }
        }

        Item{
            id:mainContent
            height: parent.height
            width: parent.width-navi.width

            VideoPage {
                id: videoPage
                visible: false
                width:parent.width
                height:parent.height-100
                x:0
                y:20
            }

            AcMainPage{
                id:acMain
                visible: false
                anchors.fill: parent
                onOpenVideo:{
                    console.log("open video:"+JSON.stringify(js))

                    acMain.visible = false
                    videoPage.visible = true
                    videoPage.title = js.title
                    AcService.getVideo(js.vId,js.sId,js.sType,funPlayVideo)
                    videoPage.setDanm(js)
                }
            }

            Rectangle {
                id: settingsButton

                height: 40
                width: 12
                color: AppStyle.accentColor
                z: 6
                anchors.top: parent.top
                anchors.right: parent.right
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        videoPage.setDanm()
                        console.debug('open settings page')
                        //dlgOpen.open()
                    }
                }
            }

            Button{
                anchors.topMargin: 50
                id:btnTest
                anchors.top: settingsButton.bottom
                anchors.right: parent.right
                height: 50
                width: 50
                text:qsTr("Rank")
                //textColor: "white"
                //color: AppStyle.accentColor
                onClicked: {
                    AcService.getRank(function(res){
                        videoPage.stop()
                        videoPage.visible = false
                        acMain.visible = true
                        acMain.updateInfo(res)
                    })
                }
            }

            Button{
                anchors.topMargin: 50
                id:btnBack
                anchors.top: btnTest.bottom
                anchors.right: parent.right
                height: 50
                width: 50
                text:qsTr("Back")
                //textColor: "white"
                //color: AppStyle.accentColor
                onClicked: {
                    videoPage.stop()
                    videoPage.visible = false
                    acMain.visible = true
                }
            }
        }
    }


    function funPlayVideo(js){
        if(0 !== js.result){
            //弹错误
            //js.error_msg
        }

        var playInfos = js.playInfo.streams
        var url = playInfos[1].playUrls[0]
        console.log("url"+url)
        videoPage.stop()
        videoPage.videoUrl = url
    }

}
