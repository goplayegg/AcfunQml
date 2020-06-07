import QtQuick 2.1
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

Label{
    id: root

    property var info: ({})
    property var speed: 1.0
    readonly property int pixPerSecond: 100
    readonly property int delayTimsMs: 5000
    z:10
    color: "#"+info.color.toString(16)
    text: info.body
    font.pixelSize: info.size
    font.family: AppStyle.fontNameMain
    font.weight: Font.Medium

    function togglePause(isPause){
        if(isPause){
            anim.item.pause()
        }else{
            anim.item.resume()
        }
        //console.log("danm togglePause:"+isPause)
    }

    function start(){
        switch(info.mode){
        case 4://底部
        case 5://顶部
            hCenter()
            break;
        default://1-滚动
            fly()
            break;
        }
        anim.item.start()
    }

    function hCenter(){
        anim.sourceComponent = compCenter
        x = (parent.width-width)/2
        //console.log("danm hCenter:")
    }

    function fly(){
        anim.sourceComponent = compFly
        x = parent.width
        //console.log("danm fly:")
    }

    Loader {
        id: anim
    }

    Component {
        id: compCenter
        NumberAnimation {
            duration: delayTimsMs
            onStopped: {
                root.destroy()
            }
        }
    }

    Component {
        id: compFly
        NumberAnimation {
            running: false
            target: root
            property: "x"
            from: root.width
            to: 0-root.width
            duration: 1000*(root.width+width)/(speed*pixPerSecond)
            onStopped: {
                root.destroy()
                //console.log("danm destroyed:"+text)
            }
        }
    }
}
