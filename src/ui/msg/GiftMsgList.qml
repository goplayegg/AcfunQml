import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles"

ScrollUpdateView {
    id: control

    Waterfall {
        id: waterfall
        anchors.left: parent.left
        anchors.right: parent.right
        cardWidth: 500
        manuallyReLayout: true

        model: ListModel {
            id: msgModel
        }
        delegate: GiftMsgCard {
            msgInfo: model.msg
        }
    }

    onUpdate: {
        console.log("refresh gifs Msg gggggggggggg:")
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
        AcService.getNotify(8, pCursor, function(res){
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
        }
        Qt.callLater(relayout)
        loading = false
    }
    function relayout(){
        waterfall.reLayout(waterfall.layoutedMaxIdx+1)
    }
}
