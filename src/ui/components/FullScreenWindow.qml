pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    id: control
    property bool smallWindow: false
    property alias content: fullItem
    visible: fullItem.children.length>0
    flags: Qt.FramelessWindowHint
    x: 0
    y: -1
    width: Screen.width
    height: Screen.height+1
    Item {
        id: fullItem
        anchors.fill: parent
    }
    onVisibleChanged: {
        if(visible){
            raise()
            requestActivate()
        }
    }
    onSmallWindowChanged: {
        if(smallWindow){
            flags = Qt.Window | Qt.WindowStaysOnTopHint
            width = 600
            height = 400
            x = screen.width - width
            y = 0
        }else{
            flags = Qt.FramelessWindowHint
            x = 0
            y = -1
            width = Screen.width
            height = Screen.height+1
        }
    }
}
