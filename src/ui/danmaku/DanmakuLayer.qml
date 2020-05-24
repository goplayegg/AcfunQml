import QtQuick 2.1
import AcfunQml 1.0
import "qrc:///ui/global/"

Item{
    id:root
    visible: false

    //property var jsonDanm: ({})
    property int timeStamp: 0
    property var componentDanm: null
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
        root.paused = isPause
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
                console.log("danm added:"+JSON.stringify(danms[i]))
            }
        }
    }
    Item {
        id: danmContainer
        anchors.fill: parent
    }

    property int flyY: 0
    property int topY: 0
    property int bottomY: height
    function getSuitY(mode){
        if(5 === mode){
            topY+=20
            if(topY>height-30)
                topY = 0;
            return topY
        }else if(4 === mode){
            bottomY-=20
            if(bottomY<0)
                bottomY=height
            return bottomY
        }else{
            flyY+=20
            if(flyY>height-30)
                flyY = 0;
            return flyY
        }
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
