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
    minimumWidth: 250
    minimumHeight: 200
    readonly property int wndFlagBase: g_commonTools.osType === "mac"?(Qt.CustomizeWindowHint | Qt.WindowMinMaxButtonsHint): Qt.FramelessWindowHint

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
        console.log("onSmallWindowChanged :"+smallWindow)
        if(smallWindow){
            fullWindow = false
            flags = Qt.Window | Qt.WindowStaysOnTopHint | wndFlagBase
            width = smallWidth
            height = smallHeight
            x = smallX
            y = smallY
            showNormal()
            fullItem.forceActiveFocus()
            console.log("changed to WindowStaysOnTopHint showNormal")
        }else{
            //fullWindow = true
            //showMinimized()
            console.log("onSmallWindowChanged exit smallWindow to normal")
        }
    }
    onFullWindowChanged: {
        console.log("onFullWindowChanged :"+fullWindow)
        if(fullWindow){
            flags = wndFlagBase
            showFullScreen()
            fullItem.forceActiveFocus()
            console.log("changed to FramelessWindowHint showFullScreen")
        }else{
            //showMinimized()
        }
    }
    onWidthChanged: {
        console.log("changed width:"+width)
        if(smallWindow)
            smallWidth = width
    }
    onHeightChanged: {
        console.log("changed height:"+height)
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
