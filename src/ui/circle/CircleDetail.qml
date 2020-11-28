//动态详情
import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import "qrc:///ui/components/card/"
import "qrc:///ui/components/comment/"

Item{
    id: control

    ScrollView {
        id: scroll
        clip: true
        anchors.fill: parent

        Column {
            width: control.width
            spacing: 20

            CircleInfoCard {
                id: card
                width: 500
                inDetail: true
            }

            CommentList {
                id: comment
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }

        Connections {
            target: scroll.ScrollBar.vertical
            function onPositionChanged() {
                if(1.0 === scroll.ScrollBar.vertical.position+scroll.ScrollBar.vertical.size){
                }
            }
            function onSizeChanged() {
                if(1.0 === scroll.ScrollBar.vertical.size){
                }
            }
        }
    }

    function refresh(){
        console.log("refresh circle detail...")
        open(card.feedInfo)
    }

    function back(){
        card.stop()
    }

    function empty(){
        return false
    }

    function open(info){
        card.repost = false
        card.feedInfo = info
        card.loadMedia()
        comment.open({"contentId": info.resourceId, "cmtType": 4})
        busyBox.running = false
    }

    function openById(mid){
        AcService.getMomentDetail(mid, function(res){
            if(0 !== res.result){
                PopMsg.showError(res, mainwindowRoot)
                return
            }
            card.repost = false
            card.feedInfo = {
                resourceType: 10,
                resourceId: mid,
                userInfo: res.moment.user,
                moment: res.moment,
                likeCount: res.moment.likeCount,
                isLike: res.moment.isLike,
                bananaCount: res.moment.bananaCount,
                isThrowBanana: res.moment.isThrowBanana,
                commentCount: res.moment.commentCount,
                time: res.moment.createTime
            }
            card.loadMedia()
        })
        comment.open({"contentId": mid, "cmtType": 4})
    }
}
