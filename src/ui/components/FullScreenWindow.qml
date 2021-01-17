pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12
import "qrc:///ui/global/"

Window {
    id: control
    property bool smallWindow: false
    property bool fullWindow: false
    property alias content: fullItem
    property int smallWidth: 600
    property int smallHeight: 400
    property int smallX: screen.width - smallWidth
    property int smallY: 0

    visible: fullItem.children.length>0
    Item {
        id: fullItem
        anchors.fill: parent
        Keys.onSpacePressed: Global.spacePressed()
        Keys.onEnterPressed: Global.enterPressed()
        Keys.onReturnPressed: Global.enterPressed()
    }
    TitleBar {
        property color hovColor: "#FFFFFF"
        visible: smallWindow
        parentWindow: control
        hoverEnabled: true
        color: hovered ? hovColor: "transparent"
    }

    onVisibleChanged: {
        if(visible){
            raise()
            requestActivate()
        }
    }
    onSmallWindowChanged: {
        if(smallWindow){
            fullWindow = false
            flags = Qt.Window | Qt.WindowStaysOnTopHint
            width = smallWidth
            height = smallHeight
            x = smallX
            y = smallY
            showNormal()
            fullItem.forceActiveFocus()
        }else{
            fullWindow = true
        }
    }
    onFullWindowChanged: {
        if(fullWindow){
            flags = Qt.FramelessWindowHint
            showFullScreen()
            fullItem.forceActiveFocus()
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
    onXChanged: {
        if(smallWindow)
            smallX = x
    }
    onYChanged: {
        if(smallWindow)
            smallY = y
    }
}
