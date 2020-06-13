pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    id: control
    property bool smallWindow: false
    property alias content: fullItem
    visible: fullItem.children.length>0
    property int smallWidth: 600
    property int smallHeight: 400

    visibility: Qt.FullScreen
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
            width = smallWidth
            height = smallHeight
            x = screen.width - width
            y = 0
            showNormal()
        }else{
            flags = Qt.FramelessWindowHint
            showFullScreen()
        }
    }
    onWidthChanged: {
        if(smallWindow)
            smallWidth = width
    }
    onHeightChanged: {
        if(smallWindow)
            smallHeight = height
    }
}
