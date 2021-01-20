import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/card/"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"

Item{
    id:root

    function empty(){
        return channelModel.count === 0
    }

    function back(){

    }

    function refresh(){
        //return
        busyBox.running = true
        if(empty()){
            AcService.getChannelList(function(res){
                if(0 !== res.result){
                    busyBox.running = false
                    PopMsg.showError(res, mainwindowRoot)
                }else{
                    channelModel.append({"name":"番剧","channelId":"bangumi"})
                    //TODO channelModel.append({"name":"精选","channelId":"MainPage"})
                    for(var idx in res.channels){
                        if("文章"===res.channels[idx].name)
                            continue
                        channelModel.append(res.channels[idx])
                    }
                    //tabBar.currentIndex = -1
                    //tabBar.currentIndex = 0
                }
            })
        }else{
            changeChannel(channelModel.get(tabBar.currentIndex).channelId)
        }
    }

    property string pcursor: ""
    property int newVideoPageNo:1
    property string crtCid:""
    function changeChannel(cid){
        busyBox.running = true
        crtCid = cid
        if("MainPage" === cid){
             AcService.getMainPage(pcursor, 10, function(res){
                 if(0 !== res.result){
                     busyBox.running = false
                     PopMsg.showError(res, mainwindowRoot)
                 }else{
                     pcursor = res.pcursor
                 }
             })
        }else if("bangumi" === cid){
            if(!bangumi.bangumiPageLoaded)
                bangumi.open()
            else
                bangumi.refreshFavorite()
        }else{
            AcService.getChannelVideo(cid, 10, function(res){
                if(0 !== res.errorid){
                    busyBox.running = false
                    PopMsg.showError(res, mainwindowRoot)
                }else{
                    newVideoPageNo = 1
                    videoModel.clear()
                    for(var idx in res.vdata){
                        if("videos" === res.vdata[idx].schema ||
                                "videos_new" === res.vdata[idx].schema){
                            var video = res.vdata[idx]
                            updateInfo(video.bodyContents)
                        }
                    }
                    busyBox.running = false
                }
            })
        }
    }

    function appendNewVideo(){
        if(empty())
            return
        busyBox.running = true
        newVideoPageNo++
        var cid = channelModel.get(tabBar.currentIndex).channelId
        AcService.getNewVideoInRegion(cid, newVideoPageNo, function(res){
            if(0 !== res.errorid){
                busyBox.running = false
                PopMsg.showError(res, mainwindowRoot)
            }else{
                updateInfo(res.vdata)
                busyBox.running = false
            }
        })
    }

    function updateInfo(js){
        var cnt = js.length
        console.log("video num:"+cnt)
        for(var i=0;i<cnt;++i){
            var jsCurVideo = js[i]
            if(undefined === jsCurVideo.user){
                continue
            }
            var videoArr = jsCurVideo.videoList
            jsCurVideo.contentId = jsCurVideo.href
            jsCurVideo.duration = jsCurVideo.duration*1000
            jsCurVideo.videoCover = jsCurVideo.img[0]
            jsCurVideo.userName = jsCurVideo.user.name
            jsCurVideo.createTime = ""
            jsCurVideo.time = jsCurVideo.time
            jsCurVideo.viewCountShow = jsCurVideo.visit.views
            jsCurVideo.commentCountShow = jsCurVideo.visit.comments
            jsCurVideo.bananaCountShow = jsCurVideo.visit.banana
            jsCurVideo.stowCount = jsCurVideo.visit.stows
            jsCurVideo.userJson = JSON.stringify(jsCurVideo.user)
            videoModel.append(jsCurVideo)
            console.log("video append:"+ jsCurVideo.title)
        }
    }

    TabBar {
         id: tabBar
         width: parent.width
         Repeater {
             id: repChannel
             model: ListModel {
                 id: channelModel
             }
             TabButton {
                 id: tabBtn
                 text: model.name
                 width: 20+tabText.implicitWidth
                 background: Rectangle {
                          implicitWidth: 100
                          implicitHeight: 40
                          color: "transparent"
                          Rectangle {
                              anchors.bottom: parent.bottom
                              anchors.bottomMargin: 5
                              anchors.left: parent.left
                              anchors.leftMargin: 5
                              visible: tabBtn.checked
                              width: tabText.width
                              height: 10
                              radius: height/2
                              gradient: Gradient {
                                  orientation: Gradient.Horizontal
                                  GradientStop {position: 0.0; color: "#ffff0000"}
                                  GradientStop {position: 1.0; color: "#05ff0000"}
                              }
                          }
                      }
                 contentItem: Text {
                          id: tabText
                          text: tabBtn.text
                          font.family: AppStyle.fontNameMain
                          font.pixelSize: tabBtn.checked ? AppStyle.font_xxxlarge: AppStyle.font_xlarge
                          font.weight: tabBar.checked ? Font.ExtraBold :Font.Normal
                          color: tabBtn.checked ? AppStyle.foregroundColor : AppStyle.secondForeColor
                          horizontalAlignment: Text.AlignHCenter
                          verticalAlignment: Text.AlignBottom
                      }
             }
         }
         onCurrentIndexChanged: {
             console.log("onCurrentIndexChanged")
             if(currentIndex >= 0)
                changeChannel(channelModel.get(currentIndex).channelId)
         }
    }
    GridView {
        id: cardView
        visible: crtCid !== "bangumi"
        anchors {
            margins: 0
            topMargin: 10
            top: tabBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        clip: true
        cellWidth: 205
        cellHeight: cellWidth
        ScrollBar.vertical : ScrollBar{
            id: scrollbar
            anchors.right: cardView.right
            width: 10
            onPositionChanged: {
                //console.log("scrollbar position:"+ position)
                if(1.0 === position+size){
                    appendNewVideo()
                }
            }
            onSizeChanged: {
                //console.log("onSizeChanged size:"+ size)
                if(1.0 === size){
                    appendNewVideo()
                }
            }
        }

        model: ListModel {
                id: videoModel
            }
        delegate: VideoInfoCard{
                infoJs: model
            }
    }

    BangumiPage {
        id: bangumi
        visible: crtCid === "bangumi"
        anchors {
            margins: 0
            topMargin: 10
            top: tabBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
