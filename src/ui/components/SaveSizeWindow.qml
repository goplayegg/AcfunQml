import QtQuick 2.12
import QtQuick.Window 2.12
import "qrc:///ui/global/"

Window {
    id: control
    //使用此组件需要设置objectName
    QtObject {
        id: d
        property bool maximized: false
        property int width: 600
        property int height: 400
        property int widthNext: 600
        property int heightNext: 400

    }

    Timer {
        id: tmSaveSize
        interval: 1000
        onTriggered: {
            if(visibility == Window.Windowed){
                d.width = d.widthNext
                d.height = d.heightNext
            }
            console.log("SaveSizeWindow onTriggered:"+control.width+ " d.width:"+d.width )
        }
    }

/* visibility枚举
QWindow::Windowed               2
QWindow::Minimized              3
QWindow::Maximized              4
QWindow::FullScreen             5
QWindow::AutomaticVisibility    1
QWindow::Hidden                 0
*/

    function saveTempSize(){
        tmSaveSize.restart()
    }
    onWidthChanged: {
        d.widthNext = width
        Qt.callLater(saveTempSize)
    }
    onHeightChanged: {
        d.heightNext = height
        Qt.callLater(saveTempSize)
    }
    onVisibilityChanged: {
        if(visibility == Window.Windowed){
            d.maximized = false
            control.width = d.width
            control.height = d.height
        }else if(visibility == Window.Maximized)
            d.maximized = true
        console.log("onVisibilityChanged : "+visibility)
    }

    Component.onCompleted: {
        //resotreSize, move to screen center
        Global.resotreSize(d, control.objectName)
        control.width = d.width
        console.log("SaveSizeWindow onCompleted 2:"+control.width)
        control.height = d.height
        if(Screen.desktopAvailableHeight<=control.height){
            control.y = 0
        }else{
            control.y = (Screen.desktopAvailableHeight - control.height)/2
        }
        control.x = 10//TODO多屏幕时Screen.desktopAvailableWidth是多个屏幕width的和，会导致显示到2个屏幕中间，需要用QDesktop

        //resotreSize Maximized
        var max = g_preference.value(control.objectName+"Maximized")
        if("true" === max) {
            d.maximized = true
            control.showMaximized()
        }

        console.log("SaveSizeWindow onCompleted finished:"+control.objectName)
    }
    onClosing: {
        console.log("SaveSizeWindow closing")
        Global.saveSize(d, control.objectName)
        g_preference.setValue(control.objectName+"Maximized", d.maximized?"true":"false")
    }
}
