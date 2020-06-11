import QtQuick 2.12

Item {
    id: control
    anchors.fill: parent
    property bool fullScreen: false
    property bool fullApp: false
    property var lastParent

    onFullAppChanged: {
        if(fullApp){
            lastParent = control.parent
            control.parent = mainwindowRoot
            control.z = 20
        }else{
            control.parent = lastParent
            control.z = 0
        }
    }

    onFullScreenChanged: {
        if(fullScreen){
            lastParent = control.parent
            control.parent = FullScreenWindow.content
        }else{
            control.parent = lastParent
        }
    }
}
