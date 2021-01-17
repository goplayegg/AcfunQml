import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: control
    property int crtIdx: 0
    property bool paused: false
    property alias delegate: rep.delegate
    property alias model: rep.model
    SwipeView{
        clip: true
        anchors.fill: parent
        currentIndex: crtIdx
        onCurrentIndexChanged: {
            crtIdx = currentIndex
        }

        Repeater {
            id: rep
        }
    }

    PageIndicator{
        count: rep.model.count
        interactive: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        currentIndex: crtIdx
        onCurrentIndexChanged: {
            crtIdx = currentIndex
        }
    }

    Timer{
        running: !paused && rep.model.count > 0 && control.visible
        interval: 3000
        repeat: true
        onTriggered: {
            if(0 === rep.model.count)
                crtIdx = 0
            else
                crtIdx = (crtIdx+1)%(rep.model.count)
        }
    }
}
