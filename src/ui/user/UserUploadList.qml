import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/card/"
import "qrc:///ui/global/"

Item{
    id: control
    property int type: 1//1-动态 2-视频 3-文章
    property int uid: 0

    function empty(){
        return resModel.count === 0
    }

    function back(){

    }

    function load(id){
        if(id === uid)
            return
        uid = id
        refresh()
    }

    function refresh(){
        resModel.clear();
        pCursor = ""
        append()
    }

    property string pCursor: ""
    property bool loading: false
    function append(){
        if("no_more" === pCursor || 0 === uid || loading)
            return
        loading = true
        if(1 === type)
            AcService.getUserProfile(uid, pCursor, updateInfo)
        else
            AcService.getUserResource(uid, type, pCursor, updateInfo)
    }

    function updateInfo(js){
        if(0 !== js.result){
            loading = false
            PopMsg.showError(js, mainwindowRoot)
            return
        }
        switch(control.type){
        case 1:
            for(var idx in js.feedList){
                resModel.append({info: js.feedList[idx], type: control.type})
            }
            break;
        case 2:
        case 3:
            for(var id in js.feed){
                resModel.append({info: js.feed[id], type: control.type})
            }
            break;
        }
        pCursor = js.pcursor
        if("no_more" === pCursor)
            resModel.append({info: {txt:qsTr("no more infomation")}, type: 0})

        loading = false
    }

    ListView {
        id: cardList
        anchors.fill: parent
        anchors.margins: 0
        clip: true
        ScrollBar.vertical: ScrollBar {
            id: scrBar
            onPositionChanged: {
                if(1.0 === position+size){
                    append()
                }
            }
            onSizeChanged: {
                if(1.0 === size){
                    append()
                }
            }
        }
        model: ListModel {
            id: resModel
        }
        delegate: Loader {
            id: ldCard
            Component {
                id: cpText
                Text {
                    width: cardList.width
                    text: model.info.txt
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Component.onCompleted: {
                switch (model.type){
                case 0:
                    ldCard.sourceComponent = cpText
                    break;
                case 1:
                    ldCard.setSource("qrc:///ui/components/card/CircleInfoCard.qml", {feedInfo: model.info, width: cardList.width})
                    break;
                case 2:
                    ldCard.setSource("qrc:///ui/components/card/VideoCard.qml", {infoJs: model.info, width: cardList.width})
                    return ""
                case 3:
                    return ""
                }
            }
        }
    }
}
