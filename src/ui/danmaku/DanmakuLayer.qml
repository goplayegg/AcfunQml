import QtQuick 2.1
import AcfunQml 1.0
import "qrc:///ui/global/"

Item {
    id:root
    visible: false

    property int timeStamp: 0
    property var componentDanm: null
    property var speed: 1.0//TODO
    property bool paused: false
    onPausedChanged: {
        togglePause(paused)
    }

    function open(js) {
        AcService.getDanm(js.vId, 0, 9, function(res){
            danmPaser.updateDanm(res)
            danmPaser.start()
            })
        visible = true
    }
    function close() {
        visible = false
        danmPaser.stop()
        var danms = danmContainer.children
        var cnt = danms.length
        for(var idx = 0; idx<cnt; ++idx){
             danms[idx].destroy()
        }
    }

    function togglePause(isPause) {
        if(isPause)
            danmPaser.pause()
        else
            danmPaser.resume()

        var danms = danmContainer.children
        var cnt = danms.length
        for(var idx = 0; idx<cnt; ++idx){
             danms[idx].togglePause(isPause)
        }
    }

    DanmakuPaser {
        id:danmPaser
        onPopDanm:{
            var danms = jsObj.list
            for(var i=0;i<danms.length;++i){
                addSingleDanm(danms[i])
                //console.log("danm added:"+JSON.stringify(danms[i]))
            }
        }
    }
    Item {
        id: danmContainer
        anchors.fill: parent
    }

    property int topY: 0
    property int bottomY: height
    function getSuitY(mode){
        if(5 === mode){
            topY+=20//TODO
            if(topY>height-30)
                topY = 0;
            return topY
        }else if(4 === mode){
            bottomY-=20
            if(bottomY<0)
                bottomY=height
            return bottomY
        }else{
            return getFlyY()
        }
    }

    readonly property int kDmXSpacing:10
    readonly property int kDmYSpacing:28
    function getFlyY(){
        var danms = danmContainer.children;
        var cnt = danms.length;
        var dmRowCnt = parseInt(root.height/kDmYSpacing);
        var y = 0;
        for(var rowIdx = 0; rowIdx<dmRowCnt; ++rowIdx){
            var bInvalidY = false;
            for(var idx = 0; idx<cnt; ++idx){
                 if(4 !== danms[idx].info.mode &&
                    5 !== danms[idx].info.mode){//只判断滚动弹幕
                     if(danms[idx].y === y &&
                        danms[idx].x + danms[idx].width + kDmXSpacing > root.width){
                         bInvalidY = true;
                         break;
                     }
                 }
            }
            if(!bInvalidY){
                break;
            }
            y+=kDmYSpacing;
        }
        return y;
    }

    function addSingleDanm(info) {
        if(null == componentDanm){
            componentDanm = Qt.createComponent("Danmaku.qml")
        }
        if(componentDanm.status === Component.Ready){
            var danmY = getSuitY(info.mode)
            console.log("danm getSuitY:"+danmY)
            var tmp = componentDanm.createObject(danmContainer,{"y":danmY, "info":info})
            tmp.start();
        }
    }

}
