import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/comment"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles"

ScrollUpdateView {
    id: control

    Waterfall {
        id: waterfall
        anchors.left: parent.left
        anchors.right: parent.right
        cardWidth: 300
        manuallyReLayout: true

        model: ListModel {
            id: msgModel
        }
        delegate: CommentMsgCard{
            id: msgCard
            msgInfo: model.msg
            onReply: {
                if(!ldEditor.active){
                    ldEditor.active = true
                }
                ldEditor.item.y = msgCard.y+msgCard.height
                ldEditor.item.replyTo(msgInfo)
            }
        }

        Loader {
            id: ldEditor
            active: false
            sourceComponent: Popup {
                padding: 0
                focus: true
                parent: waterfall
                width: parent.width
                height: editor.height
                background: Rectangle{
                    color: AppStyle.backgroundColor
                    border.color: AppStyle.thirdBkgroundColor
                    border.width: 1
                }
                CommentEditor {
                    id: editor
                    anchors.left: parent.left
                    anchors.right: parent.right
                    replySubCmt: true
                }
                function replyTo(msgInfo){
                    editor.acId = msgInfo.resourceId
                    editor.resourceType = Global.resourceType2sourceType(msgInfo.resourceType)
                    editor.replyToId = msgInfo.commentId
                    editor.replyToName = msgInfo.userName
                    editor.focusInEdit()
                    open()
                }
            }
        }
    }

    onUpdate: {
        console.log("refresh comment Msg  ccccccccccccccccc:")
        refreshMsg()
    }

    onAutoUpdateChanged: {
        if(!autoUpdate)
            waterfall.clear()
    }

    function load(refresh){
        if(refresh){
            busyBox.running = true
            pCursor = "1"
            waterfall.clear()
            control.ScrollBar.vertical.position = 0
            refreshMsg()
        }else{

        }
    }

    property string pCursor: "1"
    property bool loading: false
    function refreshMsg(){
        if("no_more" === pCursor || loading)
            return
        loading = true
        AcService.getNotify(2, pCursor, function(res){
            if(res.result !== 0){
                loading = false
                busyBox.running = false
                PopMsg.showError(res, mainwindowRoot)
                return
            }
            appendMsg(res)
        })
    }
    function appendMsg(msg){
        pCursor = msg.pCursor
        busyBox.running = false
        var cnt = msg.notifies.length
        for(var i=0;i<cnt;++i){
            msgModel.append({msg:msg.notifies[i]})
            console.log("comment append:"+ msg.notifies[i].commentContent)
        }
        Qt.callLater(relayout)
        loading = false
    }
    function relayout(){
        waterfall.reLayout(waterfall.layoutedMaxIdx+1)
    }
}
