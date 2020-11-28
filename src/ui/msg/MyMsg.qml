import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"

Item{
    id:root

    function empty(){
        return false === swip.lders[0].active
    }
    function back(){
    }
    function refresh(){
        swip.load(true)
    }

    Column {
        anchors.fill: parent
        TabBarAc {
            id: tabMsgType
            anchors.left: parent.left
            anchors.right: parent.right
            currentIndex: swip.currentIndex
            Component.onCompleted: {
                model.append({"name":qsTr("消息"), "value":0})
                model.append({"name":qsTr("评论"), "value":1})
                model.append({"name":qsTr("点赞"), "value":2})
                model.append({"name":qsTr("@我的"), "value":3})
                model.append({"name":qsTr("礼物"), "value":4})
            }
        }

        SwipeView {
            id: swip
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height-tabMsgType.height
            clip: true
            currentIndex: tabMsgType.currentIndex
            property var lders: [ldMsg, ldCmt, ldLike, ldAt, ldGift]
            function load(refresh) {
                console.log("msg swip load current idx:"+currentIndex)
                lders[currentIndex].active = true
                lders[currentIndex].item.load(refresh)
            }
            onCurrentIndexChanged: load(true)

            Loader {
                id: ldMsg
                active: false
                sourceComponent: CommentMsgList {
                    anchors.fill: parent
                    autoUpdate: parent.SwipeView.isCurrentItem
                }
            }

            Loader {
                id: ldCmt
                active: false
                sourceComponent: CommentMsgList {
                    anchors.fill: parent
                }
            }
            Loader {
                id: ldLike
                active: false
                sourceComponent: LikeMsgList {
                    anchors.fill: parent
                    autoUpdate: parent.SwipeView.isCurrentItem
                }
            }
            Loader {
                id: ldAt
                active: false
                sourceComponent: CommentMsgList {
                    anchors.fill: parent
                }
            }
            Loader {
                id: ldGift
                active: false
                sourceComponent: CommentMsgList {
                    anchors.fill: parent
                }
            }
        }
    }
}
