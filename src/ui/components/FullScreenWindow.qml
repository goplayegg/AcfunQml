pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    id: control
    property alias content: fullItem
    visible: fullItem.children.length>0
    flags: Qt.FramelessWindowHint
    x: 0
    y: -1
    width: Screen.width
    height: Screen.height+1
    //width: Screen.desktopAvailableWidth
    //height: Screen.desktopAvailableHeight
    Item {
        id: fullItem
        anchors.fill: parent
        onChildrenChanged: {
            console.log("fullItem children size:"+children.length)
        }
    }
    onVisibleChanged: {
        if(visible){
            raise()
        }
    }
}
