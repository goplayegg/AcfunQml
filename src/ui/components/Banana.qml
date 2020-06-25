import QtQuick 2.1
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

Image {
    id: root
    width: 60
    height: 48
    source: "qrc:/assets/img/common/banana.png"

    property alias duration: anim.duration
    property point fromPos: "100,100"
    property point toPos: "1,1"
    z: AppStyle.msgZ

    function start(){
        anim.start()
    }

    ParallelAnimation {
        property int duration: 2000
        id: anim
        running: false
        onStopped: {
            root.destroy()
        }
        NumberAnimation {
            target: root
            property: "x"
            from: fromPos.x
            to: toPos.x
            duration: anim.duration
            //easing.type: Easing.InQuad
        }
        NumberAnimation {
            target: root
            property: "y"
            from: fromPos.y
            to: toPos.y
            duration: anim.duration
            //easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: root
            property: "rotation"
            from: 0
            to: 360
            duration: anim.duration
            //easing.type: Easing.OutCubic
        }
    }
}
