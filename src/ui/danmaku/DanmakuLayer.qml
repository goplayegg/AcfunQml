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
        flyContainer.close()
        topBottomContainer.close()
    }

    function togglePause(isPause) {
        if(isPause)
            danmPaser.pause()
        else
            danmPaser.resume()
        flyContainer.togglePause()
        //topBottomContainer.togglePause()
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

    DanmakuContainer {
        id: flyContainer
        anchors.fill: parent
    }
    DanmakuContainer {
        id: topBottomContainer
        anchors.fill: parent
    }

    function addSingleDanm(info) {
        if(null == componentDanm){
            componentDanm = Qt.createComponent("Danmaku.qml")
        }
        if(componentDanm.status === Component.Ready){
            var danmY = getSuitY(info.mode)
            var danmParent = (info.mode !== 5 && info.mode !== 4)
                    ?flyContainer:topBottomContainer
            var tmp = componentDanm.createObject(danmParent,{"y":danmY, "info":info})
            tmp.start();
        }
    }

    function getSuitY(mode){
        if(5 === mode){
            return getTopBottomY(true)
        }else if(4 === mode){
            return getTopBottomY(false)
        }else{
            return getFlyY()
        }
    }

    readonly property int kDmXSpacing:10
    readonly property int kDmYSpacing:28
    property int dmRowCnt: parseInt(root.height/kDmYSpacing);

    function getFlyY(){
        var danms = flyContainer.children;
        var cnt = danms.length;
        var y = 0;
        for(var rowIdx = 0; rowIdx<dmRowCnt; ++rowIdx){
            var bValidY = true;
            for(var idx = 0; idx<cnt; ++idx){
                 if(danms[idx].y === y &&
                    danms[idx].x + danms[idx].width + kDmXSpacing > root.width){
                     bValidY = false;
                     break;
                 }
            }
            if(bValidY){
                break;
            }
            y+=kDmYSpacing;
        }
        return y;
    }

    function getTopBottomY(isTop){
        var danms = topBottomContainer.children;
        var cnt = danms.length;
        var y = 0;
        if(!isTop)
            y = root.height-kDmYSpacing;
        for(var rowIdx = 0; rowIdx<dmRowCnt; ++rowIdx){
            var bValidY = true;
            for(var idx = 0; idx<cnt; ++idx){
                if(danmCross(y, danms[idx].y)){
                     bValidY = false;
                     break;
                 }
            }
            if(bValidY){
                break;
            }
            if(isTop)
                y+=kDmYSpacing;
            else
                y-=kDmYSpacing;
        }
        return y;
    }

    function danmCross(y1, y2){
        return Math.abs(y1-y2) < kDmYSpacing
    }
}
