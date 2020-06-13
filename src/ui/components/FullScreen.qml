import QtQuick 2.12

Item {
    id: control
    anchors.fill: parent
    property bool fullScreen: false
    property bool fullApp: false
    property bool smallWindow: false
    property var normalParent
    state: "normal"

    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: control
                z: 0
                parent:  normalParent?normalParent:control.parent
            }
        },
        State {
            name: "fullScreen"
            PropertyChanges {
                target: control
                z: 0
                parent:  FullScreenWindow.content
            }
            PropertyChanges {
                target: FullScreenWindow
                smallWindow: false
            }
        },
        State {
            name: "fullApp"
            PropertyChanges {
                target: control
                z: 20
                parent:  mainwindowRoot
            }
        },
        State {
            name: "smallWindow"
            PropertyChanges {
                target: control
                z: 0
                parent:  FullScreenWindow.content
            }
            PropertyChanges {
                target: FullScreenWindow
                smallWindow: true
            }
        }
    ]

    onFullAppChanged: {
        //console.log("FAC-FA:"+fullApp+" FS:"+fullScreen +"SW:"+smallWindow)
        if(fullApp){
            state = "fullApp"
        }else if(fullScreen){
        }else if(smallWindow){
        }else{
            state = "normal"
        }
    }

    onFullScreenChanged: {
        //console.log("FSC-FA:"+fullApp+" FS:"+fullScreen +"SW:"+smallWindow)
        if(fullScreen){
            state = "fullScreen"
        }else if(smallWindow){
        }else if(fullApp){
        }else{
            state = "normal"
            mainwindow.raise()
            mainwindow.requestActivate()
        }
    }

    onSmallWindowChanged: {
        //console.log("SWC-FA:"+fullApp+" FS:"+fullScreen +"SW:"+smallWindow)
        if(smallWindow){
            state = "smallWindow"
        }else if(fullScreen){
        }else if(fullApp){
        }else{
            state = "normal"
            mainwindow.raise()
            mainwindow.requestActivate()
        }
    }
}
