import QtQuick 2.12
import QtQuick.Controls 2.12

ScrollView {
    id: scroll
    clip: true
    property bool autoUpdate: true

    signal update()

    Connections {
        target: scroll.ScrollBar.vertical
        function onPositionChanged() {
            if(!autoUpdate)
                return
            if(0.99 < target.position+target.size){
                console.log("scrollbar position:"+ target.position)
                update()
            }
        }
        function onSizeChanged() {
            if(!autoUpdate)
                return
            if(1.0 === target.size){
                console.log("scrollbar size:"+ target.size)
                update()
            }
        }
    }
}
